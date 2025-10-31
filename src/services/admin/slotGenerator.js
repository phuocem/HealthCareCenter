// services/slotGenerator.js
import { supabase } from '../../api/supabase';

// Lấy ngày tiếp theo của 1 thứ (vd: Thứ 3 tiếp theo)
const getNextDayOfWeek = (dayName) => {
  const days = ['Chủ nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];
  const target = days.indexOf(dayName);
  const today = new Date();
  const current = today.getDay();
  let diff = target - current;
  if (diff <= 0) diff += 7;
  const next = new Date(today);
  next.setDate(today.getDate() + diff);
  return next;
};

// Chia ca thành slot (60 phút)
const generateTimeSlots = (start, end, interval = 60) => {
  const slots = [];
  let [sh, sm] = start.split(':').map(Number);
  let [eh, em] = end.split(':').map(Number);
  let current = sh * 60 + sm;
  const endMin = eh * 60 + em;

  while (current + interval <= endMin) {
    const s = `${String(Math.floor(current / 60)).padStart(2, '0')}:${String(current % 60).padStart(2, '0')}`;
    const e = `${String(Math.floor((current + interval) / 60)).padStart(2, '0')}:${String((current + interval) % 60).padStart(2, '0')}`;
    slots.push([s, e]);
    current += interval;
  }
  return slots;
};

// Sinh slot cho 7 ngày tới
export const generateSlotsForNext7Days = async (doctorId) => {
  const { data: templates } = await supabase
    .from('appointment_slots')
    .select('day_of_week, start_time, end_time')
    .eq('doctor_id', doctorId)
    .eq('is_template', true);

  const slotsToInsert = [];

  for (const temp of templates) {
    const nextDate = getNextDayOfWeek(temp.day_of_week);
    const dateStr = nextDate.toISOString().split('T')[0];

    const timeSlots = generateTimeSlots(temp.start_time, temp.end_time, 60);

    for (const [start, end] of timeSlots) {
      slotsToInsert.push({
        doctor_id: doctorId,
        is_template: false,
        work_date: dateStr,
        start_time: start,
        end_time: end,
        max_patients: 5,
        booked_count: 0,
      });
    }
  }

  if (slotsToInsert.length > 0) {
    await supabase
      .from('appointment_slots')
      .upsert(slotsToInsert, {
        onConflict: 'doctor_id,work_date,start_time',
      });
  }
};