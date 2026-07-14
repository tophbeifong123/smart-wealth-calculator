# 🪙 Smart Wealth Calculator (แอปคำนวณแผนออมทรัพย์ & ดอกเบี้ยทบต้น)

[![Flutter Version](https://img.shields.io/badge/Flutter-^3.19.0-blue.svg)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-^3.12.2-orange.svg)](https://dart.dev)
[![State Management](https://img.shields.io/badge/State--Management-BLoC%20%2F%20Cubit-green.svg)](https://pub.dev/packages/flutter_bloc)
[![Licence](https://img.shields.io/badge/license-none-lightgrey.svg)](#)

แอปพลิเคชันคำนวณและวางแผนการเงินส่วนบุคคลระดับพรีเมียม พัฒนาด้วย **Flutter** และ **Dart** ได้รับการออกแบบตามแนวคิดสถาปัตยกรรมระดับสากล **Clean Architecture (Feature-First)** และใช้การจัดการสถานะแบบ **BLoC Pattern** เพื่อความเสถียรและบำรุงรักษาโค้ดในระยะยาวได้ง่าย

---

## 🌟 คุณสมบัติเด่น (Key Features)

1. **📈 เครื่องมือคำนวณดอกเบี้ยทบต้น (Compound Interest Calculator):**
   - คำนวณการเติบโตของเงินออมจากเงินต้นเริ่มต้นและเงินฝากรายเดือน
   - ปรับเลือกความถี่ในการทบต้นได้ยืดหยุ่น (รายปี, รายไตรมาส, รายเดือน, รายวัน)
   - เปรียบเทียบผลลัพธ์ระหว่างการฝากเงินช่วง "ต้นงวด" และ "สิ้นงวด"
2. **🎯 เครื่องมือวางแผนเป้าหมายการออม (Savings Goal Planner):**
   - คำนวณจำนวนเงินที่ต้องเก็บออมเพิ่มต่อเดือนเพื่อพิชิตเป้าหมายที่ตั้งไว้
   - แสดงสัดส่วนเป็นเปอร์เซ็นต์ระหว่างเงินต้นจริงที่ฝากเทียบกับดอกเบี้ยทบต้นที่สะสมเพิ่มขึ้น
3. **👵 เครื่องมือวางแผนการเงินเกษียณ (Retirement Planner):**
   - คำนวณหาขนาดของเงินกองทุนเกษียณสะสมที่ควรมีในวันเกษียณ
   - **ปรับค่าครองชีพตามอัตราเงินเฟ้อ (Inflation-adjusted):** แปลงค่าใช้จ่ายในวันนี้ให้เห็นค่าจริงตามมูลค่าเงินในอนาคต ณ วันเกษียณ
   - คำนวณเงินออมสะสมช่วงทำงาน และทำแบบจำลองการทยอยถอนเงินใช้อย่างละเอียดจนถึงสิ้นสุดอายุขัย
4. **🎨 ประสบการณ์ใช้งานระดับพรีเมียม (Premium UX/UI):**
   - **Dual Themes:** รองรับการสลับสไตล์ระหว่างธีมสว่าง (Light Mode) และธีมมืดพรีเมียม (Dark Mode) ได้ในคลิกเดียวผ่าน ThemeBloc
   - **Interactive Charts:** กราฟจำลองการสะสมมูลค่าแบบ Interactive แตะเพื่ออ่านข้อมูลจุดพิกัดเงินต้นและยอดรวมได้
   - **Easy Inputs:** แถบเลื่อนปรับค่า (Slider) พร้อมทางเลือกแตะตัวเลขผลลัพธ์เพื่อกรอกด้วยแป้นพิมพ์ได้เจาะจง

---

## 🏗️ การออกแบบสถาปัตยกรรมซอฟต์แวร์ (Architecture Design)

โปรเจกต์นี้ได้รับการปรับปรุงโค้ด (Refactored) จากระบบเดิมขึ้นมาเป็นระบบที่ดีขึ้นตามหลัก **Clean Code** โดยอ้างอิงหลักการดังนี้:

### 1. Feature-First Structure
แยกโค้ดหลักของโปรแกรมออกตามโมดูลการทำงาน (Features) เพื่อความเป็นเอกเทศและขยายระบบได้ง่าย
* **Core**: เก็บส่วนกลาง เช่น การจัดการธีมหลักของระบบ
* **Features**: แยกฟีเจอร์คำนวณ (`calculator`) ออกเป็นของตัวเองอย่างชัดเจน

### 2. Clean Architecture Layering
ภายในฟีเจอร์จะแยกเป็น 3 ชั้นย่อยเพื่อให้สอดคล้องกับหลักการลบล้างความผูกมัด (Decoupling):
* **Domain Layer**: เก็บกฎและข้อบังคับทางธุรกิจ (Business Rules) รวมถึงคลาสข้อมูล (Entity/Model) และสัญญากำหนดการทำงานของข้อมูล (Repository Interfaces) ชั้นนี้จะไม่มีการพึ่งพาโมดูลภายนอกเลย
* **Data Layer**: เป็นผู้ลงมือทำงานจริงตามสัญญาของ Domain (Repository Implementation) เช่น การคำนวณตัวเลขและสถิติสะสมจริง
* **Presentation Layer**: ส่วนการแสดงผลบนหน้าจอ (UI Pages/Widgets) และการควบคุมสถานะ (BLoC)

---

## 📂 โครงสร้างโฟลเดอร์ใหม่ (Project Directory Structure)

```text
lib/
├── core/                               # ส่วนกลางที่ใช้ร่วมกันในแอป
│   └── theme/
│       ├── app_theme.dart              # คลาสสำหรับจัดการธีม Light/Dark
│       └── bloc/                       # BLoC สำหรับสลับธีมของแอป
│           ├── theme_bloc.dart
│           ├── theme_event.dart
│           └── theme_state.dart
├── features/                           # ส่วนของฟีเจอร์การทำงานหลัก
│   └── calculator/
│       ├── domain/                     # เลเยอร์เก็บ Model และสัญญา Interface
│       │   ├── models/                 # ตัวแบบสูตรคำนวณทางการเงิน
│       │   │   ├── compound_interest_model.dart
│       │   │   ├── savings_goal_model.dart
│       │   │   └── retirement_model.dart
│       │   └── repositories/           # สัญญาการเรียกข้อมูลคำนวณ
│       │       └── calculator_repository.dart
│       ├── data/                       # เลเยอร์จัดการประมวลผลข้อมูลจริง
│       │   └── repositories/           # 구현 (Implementation) ของการคำนวณ
│       │       └── calculator_repository_impl.dart
│       └── presentation/               # เลเยอร์จัดการ UI และสถานะหน้าจอ
│           ├── bloc/                   # เครื่องมือควบคุม Logic ของเครื่องคิดเลข
│           │   ├── calculator_bloc.dart
│           │   ├── calculator_event.dart
│           │   └── calculator_state.dart
│           ├── pages/                  # หน้าจอหลักแสดงผลตัวสลับแท็บ
│           │   └── dashboard_page.dart
│           └── widgets/                # ส่วนประกอบหน้าจอย่อย (Stateless)
│               ├── breakdown_table.dart
│               ├── custom_card.dart
│               ├── custom_slider.dart
│               ├── growth_chart.dart
│               └── result_card.dart
└── main.dart                           # ไฟล์เริ่มต้นโปรแกรมและขึ้นทะเบียน Providers
```

---

## 🛠️ เทคโนโลยีและแพ็กเกจที่เลือกใช้ (Tech Stack)

- **Framework:** [Flutter SDK](https://flutter.dev) (Channel Stable, แนะนำเวอร์ชัน 3.19.0 ขึ้นไป)
- **Language:** [Dart](https://dart.dev) (SDK ^3.12.2)
- **State Management:** [flutter_bloc](https://pub.dev/packages/flutter_bloc) สำหรับแยกแยะ UI และ Logic ด้วยสถาปัตยกรรมแบบ Reactive
- **Object Equality:** [equatable](https://pub.dev/packages/equatable) ช่วยตรวจจับความเปลี่ยนแปลงของข้อมูลเพื่อป้องกัน Widget Rebuild โดยไม่จำเป็น
- **Data Visualization:** [fl_chart](https://pub.dev/packages/fl_chart) ชาร์ตกราฟพื้นที่จำลองข้อมูลสะสม
- **Typography:** [google_fonts](https://pub.dev/packages/google_fonts) ใช้ฟอนต์ Prompt ของภาษาไทย
- **Formatting:** [intl](https://pub.dev/packages/intl) จัดการแสดงผลตัวเลขและสัญลักษณ์สกุลเงินบาท (฿)

---

## 🚀 ขั้นตอนการติดตั้งและใช้งาน (Setup & Run Guide)

### 1. ดาวน์โหลดโปรเจกต์ (Clone Repository)
```bash
git clone https://github.com/tophbeifong123/smart-wealth-calculator.git
cd smart-wealth-calculator
```

### 2. ดาวน์โหลดโมดูล (Install Dependencies)
```bash
flutter pub get
```

### 3. รันการทดสอบและวิเคราะห์โค้ด (Testing & Lints)
ตรวจสอบคุณภาพโค้ดและรัน Widget Test ทั้งหมดเพื่อให้มั่นใจว่าระบบไม่มีบั๊ก:
```bash
flutter analyze
flutter test
```

### 4. รันแอปพลิเคชัน (Run App)
```bash
flutter run
```

---

## 🤝 กฎกติกามารยาทสำหรับงานทีม (Git Best Practices)

- **Commit Message Format (Conventional Commits)**:
  - `feat: ...` เพิ่มฟีเจอร์หรือวิดเจ็ตใหม่ (เช่น `feat: add PDF sharing`)
  - `fix: ...` แก้บั๊กหรือแก้สูตรคำนวณที่ผิดพลาด (เช่น `fix: correct inflation rate calculation`)
  - `refactor: ...` ปรับปรุงระเบียบโค้ดภายในแต่อุปกรณ์ทำงานเหมือนเดิม
  - `docs: ...` แก้ไขเอกสารคำอธิบายหรือคู่มือ (เช่น `docs: update README.md`)
- **Coding Style**: รันคำสั่งนี้เพื่อสแกนและจัดข้อความช่องไฟก่อนทำการ commit เสมอ:
  ```bash
  flutter format .
  ```
