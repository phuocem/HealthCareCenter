// src/controllers/searchDoctorController.js
import { searchDoctorsService } from '../../services/patient/searchDoctorService';

/**
 * 🧠 Xử lý logic tìm kiếm bác sĩ
 * @param {string} keyword - Từ khóa nhập vào
 */
export const searchDoctorController = async (keyword) => {
  if (!keyword.trim()) return [];

  const results = await searchDoctorsService(keyword);
  return results || [];
};
