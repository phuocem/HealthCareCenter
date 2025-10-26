
export const formatDate = (date) => {
  if (!date) return 'Chưa có';
  try {
    const [year, month, day] = date.split('-');
    return `${day}/${month}/${year}`;
  } catch {
    return 'Chưa có';
  }
};

export const formatGender = (gender) => {
  if (!gender) return 'Chưa có';
  return gender === 'male' ? 'Nam' : gender === 'female' ? 'Nữ' : 'Khác';
};

export const formatRole = (role) => {
  return role === 'patient'
    ? 'Bệnh nhân'
    : role === 'doctor'
    ? 'Bác sĩ'
    : role || 'Bệnh nhân';
};
