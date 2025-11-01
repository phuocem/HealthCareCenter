// src/services/doctorService.js
import { supabase } from '../../api/supabase';

// === HÀM TỰ ĐỘNG SINH SLOT ===
const generateSlotsForNext7Days = async (doctorId, selectedDays, startTime, endTime) => {
  const slotsToInsert = [];

  // Lấy ngày tiếp theo của 1 thứ
  const getNextDate = (dayName) => {
    const days = ['Chủ nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];
    const target = days.indexOf(dayName);
    const today = new Date();
    const current = today.getDay();
    let diff = target - current;
    if (diff <= 0) diff += 7;
    const next = new Date(today);
    next.setDate(today.getDate() + diff);
    return next.toISOString().split('T')[0]; // YYYY-MM-DD
  };

  // Chia ca thành slot 60 phút
  const generateTimeSlots = (start, end) => {
    const slots = [];
    let [sh, sm] = start.split(':').map(Number);
    let [eh, em] = end.split(':').map(Number);
    let current = sh * 60 + sm;
    const endMin = eh * 60 + em;

    while (current + 60 <= endMin) {
      const s = `${String(Math.floor(current / 60)).padStart(2, '0')}:${String(current % 60).padStart(2, '0')}`;
      const e = `${String(Math.floor((current + 60) / 60)).padStart(2, '0')}:${String((current + 60) % 60).padStart(2, '0')}`;
      slots.push([s, e]);
      current += 60;
    }
    return slots;
  };

  for (const day of selectedDays) {
    const workDate = getNextDate(day);
    const timeSlots = generateTimeSlots(startTime, endTime);

    for (const [s, e] of timeSlots) {
      slotsToInsert.push({
        doctor_id: doctorId,
        is_template: false,
        work_date: workDate,
        start_time: s,
        end_time: e,
        max_patients: 5,
        booked_count: 0,
      });
    }
  }

  if (slotsToInsert.length > 0) {
    const { error } = await supabase
      .from('appointment_slots')
      .upsert(slotsToInsert, { onConflict: 'doctor_id,work_date,start_time' });

    if (error) console.error('Lỗi sinh slot:', error);
  }
};

// === TẠO BÁC SĨ + LỊCH MẪU + SLOT ===
export const createDoctorWithRoleService = async (
  email,
  password,
  fullName,
  departmentId,
  scheduleList = [], // ← [{ day_of_week, start_time, end_time }]
  role = 2
) => {
  // 1. Tạo tài khoản Auth
  const { data: authData, error: authError } = await supabase.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
  });

  if (authError) {
    if (authError.message.includes('already registered')) {
      return { success: false, message: `Email ${email} đã tồn tại` };
    }
    throw new Error(authError.message);
  }

  const userId = authData.user.id;

  // 2. Tạo profile
  const { data: existingProfile } = await supabase
    .from('user_profiles')
    .select('id')
    .eq('id', userId)
    .maybeSingle();

  if (!existingProfile) {
    const { error: profileError } = await supabase
      .from('user_profiles')
      .insert([{ id: userId, full_name: fullName, email, role_id: role }]);
    if (profileError) throw new Error(profileError.message);
  }

  // 3. Tạo bác sĩ
  const { data: existingDoctor } = await supabase
    .from('doctors')
    .select('id')
    .eq('id', userId)
    .maybeSingle();

  if (!existingDoctor) {
    const { error: doctorError } = await supabase
      .from('doctors')
      .insert([{ id: userId, department_id: departmentId }]);
    if (doctorError) throw new Error(doctorError.message);
  }

  // 4. LƯU LỊCH MẪU (template)
 if (scheduleList.length > 0) {
    const templateData = scheduleList.map(s => ({
      doctor_id: userId,
      is_template: true,
      day_of_week: s.day_of_week,
      start_time: s.start_time,
      end_time: s.end_time,
      max_patients: 30,
    }));

    const { error: tempErr } = await supabase
      .from('appointment_slots')
      .insert(templateData);
    if (tempErr) throw tempErr;

    // TỰ ĐỘNG SINH SLOT CHO 7 NGÀY TỚI
    await generateSlotsForNext7Days(userId, scheduleList);
  }

  return { success: true, message: `Đã tạo bác sĩ ${fullName}`, userId };
};

// === CÁC HÀM KHÁC (GIỮ NGUYÊN) ===
export const getAllDoctorsService = async () => {
  const { data, error } = await supabase
    .from('doctors')
    .select(`
      id,
      department_id,
      specialization,
      experience_years,
      room_number,
      max_patients_per_slot,
      bio,
      created_at,
      user_profiles (
        full_name,
        email,
        role_id,
        roles ( name )
      ),
      departments ( name )
    `)
    .order('created_at', { ascending: false });

  if (error) throw new Error(error.message);
  return data;
};

export const updateDoctorService = async (userId, updateData = {}) => {
  const updates = {};

  if (updateData.fullName) {
    const { error: profileError } = await supabase
      .from('user_profiles')
      .update({ full_name: updateData.fullName })
      .eq('id', userId);
    if (profileError) throw new Error(profileError.message);
  }

  if (updateData.departmentId) updates.department_id = updateData.departmentId;
  if (updateData.specialization) updates.specialization = updateData.specialization;
  if (updateData.experience_years) updates.experience_years = updateData.experience_years;
  if (updateData.room_number) updates.room_number = updateData.room_number;
  if (updateData.max_patients_per_slot) updates.max_patients_per_slot = updateData.max_patients_per_slot;
  if (updateData.bio) updates.bio = updateData.bio;

  if (Object.keys(updates).length > 0) {
    const { error: doctorError } = await supabase
      .from('doctors')
      .update(updates)
      .eq('id', userId);
    if (doctorError) throw new Error(doctorError.message);
  }

  return { success: true, message: 'Đã cập nhật thông tin bác sĩ' };
};
export const deleteDoctorService = async (userId) => {
  try {
    // 1. XÓA TẤT CẢ SLOT TRƯỚC (BẮT BUỘC!)
    const { error: slotError } = await supabase
      .from('appointment_slots')
      .delete()
      .eq('doctor_id', userId);

    if (slotError) throw slotError;

    // 2. XÓA doctors (giờ đã an toàn)
    const { error: doctorError } = await supabase
      .from('doctors')
      .delete()
      .eq('id', userId);

    if (doctorError) throw doctorError;

    // 3. XÓA profile
    const { error: profileError } = await supabase
      .from('user_profiles')
      .delete()
      .eq('id', userId);

    if (profileError) throw profileError;

    // 4. XÓA auth (cuối cùng)
    const { error: authError } = await supabase.auth.admin.deleteUser(userId);
    if (authError) throw authError;

    return { success: true, message: 'Đã xóa bác sĩ thành công' };
  } catch (error) {
    return { success: false, message: error.message };
  }
};

// === TẠO SLOT CỤ THỂ (DÙNG KHI CẦN) ===
export const createDoctorSlotService = async (doctorId, workDate, startTime, endTime, maxPatients = 5) => {
  const { data, error } = await supabase
    .from('appointment_slots')
    .insert([
      {
        doctor_id: doctorId,
        is_template: false,
        work_date: workDate,
        start_time: startTime,
        end_time: endTime,
        max_patients: maxPatients,
        booked_count: 0,
      },
    ])
    .select()
    .single();

  if (error) throw new Error(error.message);
  return data;
};