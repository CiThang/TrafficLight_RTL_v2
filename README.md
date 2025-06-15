# 🚦 Traffic Light Controller (Verilog)

This project implements a **traffic light controller** in Verilog, simulating a real-world traffic light system with red, yellow, and green lights, along with a 7-segment display to show the remaining time for each light.

---

![image](https://github.com/user-attachments/assets/22b67d8a-2496-452f-97d7-29e328cdaad8)


## 📦 Module Overview

The system is composed of four main modules:

# 🚦 Bộ Điều Khiển Đèn Giao Thông - Dự Án Verilog

## 📄 Mô tả

Dự án này hiện thực một **bộ điều khiển đèn giao thông** hoàn chỉnh sử dụng **Verilog HDL**, bao gồm các thành phần: **chia xung**, **máy trạng thái**, **bộ đếm thời gian cho từng pha đèn**, và **hiển thị LED 7 đoạn**. Thiết kế sử dụng phương pháp mô-đun (modular RTL) để dễ mở rộng và bảo trì.

---

## 📦 Danh sách các module

### 1. `Clock Divider - clock_divider.v`
- **Chức năng**: Chia xung từ 10MHz xuống 1Hz để sử dụng làm nhịp chính dễ quan sát.
- **Ngõ vào**: `clk` (10MHz)
- **Ngõ ra**: `clk_1Hz`
- **Kết quả**: Sử dụng làm xung đồng hồ hệ thống cho các module khác.

---

### 2. `traffic_fsm.v`
- **Chức năng**: Máy trạng thái hữu hạn điều khiển thứ tự các pha đèn giao thông.
- **Các trạng thái**: `IDLE` → `GREEN` → `YELLOW` → `RED` (lặp lại).
- **Ngõ ra**:
  - `light[2:0]`: Đèn đang bật (bit 0: Xanh, bit 1: Vàng, bit 2: Đỏ).
  - `light_cnt_init[2:0]`: Tín hiệu khởi tạo lại bộ đếm thời gian cho đèn tương ứng.

---

### 3. `light_counter.v`
- **Chức năng**: Đếm ngược thời gian cho từng pha đèn.
- **Tham số có thể cấu hình**:
  - `pGREEN_INIT_VAL`: Thời gian đèn xanh.
  - `pYELLOW_INIT_VAL`: Thời gian đèn vàng.
  - `pRED_INIT_VAL`: Thời gian đèn đỏ.
- **Ngõ vào**: `init[2:0]` — kích hoạt khởi tạo lại bộ đếm.
- **Ngõ ra**: `cnt_out`, `last` (tín hiệu kết thúc đếm)

---

### 4. `second_counter.v`
- **Chức năng**: Đếm ngược từ 99 về 0 (chu kỳ 1 giây).
- **Ngõ ra**:
  - `last`: Bằng 1 khi đếm về 0.
  - `pre_last`: Bằng 1 khi đếm về 1.
  - `count[6:0]`: Giá trị hiện tại của bộ đếm.

---

### 5. `7-Segment Display Controller`
- **Chức năng**: Chuyển đổi `count_value` thành định dạng LED 7 đoạn để hiển thị 2 chữ số.
- **Ngõ vào**: `count_value`
- **Ngõ ra**: `display_led[15:0]` (2 chữ số × 7 đoạn + chấm)

---

## 🧪 Testbench

Các testbench được cung cấp để mô phỏng và kiểm thử từng module:

- ✅ `traffic_fsm_tb.v`: Kiểm tra hoạt động và chuyển trạng thái của FSM (`light`, `light_cnt_init`).
- ✅ `light_counter_tb.v`: Kiểm tra bộ đếm thời gian của từng pha đèn.
- ✅ `second_counter_tb.v`: Kiểm tra đếm từ 99 về 0 và các tín hiệu `last`, `pre_last`.

---



## 📐 Top Module Port Description

| Port Name     | Direction | Width | Description                           |
|---------------|-----------|--------|---------------------------------------|
| `clk`         | input     | 1      | 10MHz system clock                    |
| `rst_n`       | input     | 1      | Active-low asynchronous reset         |
| `en`          | input     | 1      | Enable signal                         |
| `red_light`   | output    | 1      | Control signal for red light          |
| `yellow_light`| output    | 1      | Control signal for yellow light       |
| `green_light` | output    | 1      | Control signal for green light        |
| `display_led` | output    | 16     | Two-digit 7-segment display output    |

---

## 🛠️ Specifications

- **Clock Frequency**: 10MHz
- **Red Light Duration**: 18 seconds  
- **Yellow Light Duration**: 3 seconds  
- **Green Light Duration**: 15 seconds  
- **Display**: 2-digit 7-segment LED display

---

## 🧠 Behavior

1. At startup, the system begins in the **Red** state for 18 seconds.
2. Transitions to **Green** for 15 seconds.
3. Then to **Yellow** for 3 seconds.
4. The cycle repeats endlessly.
5. The remaining time for each light is displayed on the 7-segment display.

---

## 💡 Notes

- The system is fully synchronous with the 1Hz derived clock.
- All transitions are based on time values programmed into the FSM.
- Display uses binary to 7-segment conversion logic.

---

## 📷 Block Diagram

![image](https://github.com/user-attachments/assets/973ac5c3-eb01-422d-bff7-e7d481a996d0)

---

## 🔁 Future Improvements
- Add pedestrian crossing logic.
- Support for night mode or flashing yellow.
- Implement testbench and simulation scripts.

# TrafficLight_RTL_v2
