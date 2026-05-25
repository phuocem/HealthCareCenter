<p align="center">
  <img src="assets/images/logo.png" alt="HealthX Logo" width="180" style="border-radius: 24px; box-shadow: 0 8px 24px rgba(0,0,0,0.15);" />
</p>

<h1 align="center">HealthX</h1>
<p align="center"><strong>Hệ thống Quản lý Y tế Toàn diện & Tiện ích Chăm sóc Sức khỏe Di động</strong></p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue.svg?style=flat-square&logo=flutter" alt="Flutter" />
  <img src="https://img.shields.io/badge/Supabase-Database%20%26%20Auth-green.svg?style=flat-square&logo=supabase" alt="Supabase" />
  <img src="https://img.shields.io/badge/GetX-State%20Management-purple.svg?style=flat-square" alt="GetX" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey.svg?style=flat-square" alt="Platforms" />
</p>

---

**HealthX** là giải pháp y tế di động toàn diện và hiện đại, giúp tối ưu hóa quy trình quản lý bệnh viện và nâng cao trải nghiệm chăm sóc sức khỏe cho bệnh nhân. Ứng dụng cung cấp một nền tảng kết nối liền mạch, an toàn và trực quan giữa bệnh nhân, bác sĩ và đội ngũ quản lý y tế.

---

## 🚀 Tính năng chính

### 🏥 Dành cho Bệnh nhân
* **Đặt lịch khám thông minh:** Tìm kiếm bác sĩ theo chuyên khoa và đặt lịch khám nhanh chóng.
* **Quản lý hồ sơ y tế:** Lưu trữ lịch sử khám bệnh, đơn thuốc điện tử và kết quả cận lâm sàng.
* **Theo dõi sức khỏe:** Cập nhật các chỉ số sinh tồn và nhận thông báo nhắc lịch tự động.

### 👨‍⚕️ Dành cho Bác sĩ & Nhân viên
* **Quản lý lịch hẹn:** Xem và điều phối danh sách bệnh nhân khám trong ngày với bảng điều khiển trực quan.
* **Bệnh án điện tử:** Cập nhật chẩn đoán, kê đơn thuốc và chỉ định xét nghiệm trực tiếp trên ứng dụng.
* **Quản lý kho dược:** Theo dõi tồn kho, hạn sử dụng và quy trình cấp phát thuốc chính xác.

### 🛡️ Quản trị hệ thống (Admin)
* **Quản lý nhân sự:** Điều phối đội ngũ bác sĩ, nhân viên và phân quyền chi tiết.
* **Cấu hình dịch vụ:** Quản lý danh mục phòng ban, dịch vụ khám và bảng giá y tế.

---

## 🛠️ Công nghệ sử dụng

* **Frontend:** [Flutter](https://flutter.dev/) (Dart) - Đảm bảo trải nghiệm mượt mà, hiệu năng cao trên cả hai nền tảng Android & iOS.
* **State Management:** [GetX](https://pub.dev/packages/get) - Tối ưu hóa hiệu năng, điều hướng luồng và quản lý trạng thái ứng dụng.
* **Backend:** [Supabase](https://supabase.com/) (Postgres) - Hệ thống lưu trữ dữ liệu thời gian thực, bảo mật cấp cao (RLS) và đồng bộ tức thì.
* **Authentication:** Supabase Auth - Xác thực và phân quyền người dùng an toàn.

---

## 👥 Đội ngũ phát triển

Dự án được nghiên cứu và phát triển bởi:

* 👨‍💻 **[Phước](https://github.com/T-Phuoc)**
* 👩‍💻 **[Thảo & Quỳnh](https://github.com/LeNguyenThaoQuynh)**
* 👨‍💻 **[Phúc](https://github.com/phuczkz)**
* 👨‍💻 **[Phước Em](https://github.com/phuocem)**

---

## 📥 Hướng dẫn cài đặt

1. **Clone dự án:**
   ```bash
   git clone https://github.com/phuocem/-HealthCareCenter.git
   ```

2. **Cài đặt các dependencies:**
   ```bash
   flutter pub get
   ```

3. **Cấu hình môi trường:**
   * Tạo file `.env` tại thư mục gốc của dự án.
   * Cấu hình các biến môi trường của bạn (URL và API Key của Supabase):
     ```env
     SUPABASE_URL=https://your-supabase-url.supabase.co
     SUPABASE_ANON_KEY=your-supabase-anon-key
     ```

4. **Chạy ứng dụng:**
   ```bash
   flutter run
   ```

---
<p align="center">© 2026 HealthX Team. All rights reserved.</p>
