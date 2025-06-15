# 🚦 Bộ Điều Khiển Đèn Giao Thông (Verilog)

Dự án này hiện thực một **bộ điều khiển đèn giao thông** bằng Verilog, mô phỏng hệ thống đèn thực tế với 3 pha: **đỏ**, **vàng**, **xanh**, cùng màn hình LED 7 đoạn để hiển thị thời gian còn lại của mỗi pha đèn.

---

![image](https://github.com/user-attachments/assets/22b67d8a-2496-452f-97d7-29e328cdaad8)

## 📦 Tổng Quan Các Module

Hệ thống gồm 5 module chính như sau:

---

## 📄 Mô tả

Thiết kế sử dụng các mô-đun độc lập bao gồm:
- Bộ chia xung (clock divider)
- Máy trạng thái điều khiển đèn (FSM)
- Bộ đếm thời gian cho từng pha đèn (light counter)
- Bộ đếm giây tổng quát (second counter)
- Bộ giải mã LED 7 đoạn (7-segment display)

Thiết kế được viết bằng Verilog HDL với kiến trúc **modular RTL**, giúp dễ bảo trì và mở rộng sau này.

---

## 📦 Danh sách các module

### 1. `Clock Divider - clock_divider.v`
- **Chức năng**: Chia xung từ 10MHz xuống 1Hz, giúp con người dễ theo dõi hơn.
- **Ngõ vào**: `clk` (xung 10MHz)
- **Ngõ ra**: `clk_1Hz` (xung 1Hz)
- **Ứng dụng**: Làm xung nhịp chính cho toàn hệ thống.
- **Mô phỏng**
![image](https://github.com/user-attachments/assets/9c697f09-e145-496e-a534-905a16bb2daa)
---

### 2. `traffic_fsm.v`
- **Chức năng**: Máy trạng thái điều khiển tuần tự đèn giao thông.
- **Chu trình đèn**: `IDLE` → `XANH` → `VÀNG` → `ĐỎ` → quay lại `XANH`.
- **Ngõ ra**:
  - `light[2:0]`: Trạng thái đèn hiện tại (bit 0: xanh, 1: vàng, 2: đỏ).
  - `light_cnt_init[2:0]`: Tín hiệu yêu cầu bộ đếm thời gian khởi động lại theo từng pha.
- **Mô phỏng**
![image](https://github.com/user-attachments/assets/87fab8b4-898e-4ced-a12e-d79417ca2009)
---

### 3. `light_counter.v`
- **Chức năng**: Đếm ngược thời gian còn lại cho mỗi pha đèn.
- **Tham số tùy chỉnh**:
  - `pGREEN_INIT_VAL`: Thời gian đèn xanh.
  - `pYELLOW_INIT_VAL`: Thời gian đèn vàng.
  - `pRED_INIT_VAL`: Thời gian đèn đỏ.
- **Ngõ vào**: `init[2:0]` — tín hiệu yêu cầu khởi tạo đếm lại cho pha tương ứng.
- **Ngõ ra**:
  - `cnt_out`: Giá trị đếm hiện tại.
  - `last`: Bằng 1 khi đếm về 0.
- **Mô phỏng**
![image](https://github.com/user-attachments/assets/c6d11080-db08-48d6-9cce-d1bbfa969f6a)
---

### 4. `second_counter.v`
- **Chức năng**: Bộ đếm giây từ 99 về 0, sử dụng trong mỗi chu kỳ đèn.
- **Ngõ ra**:
  - `last`: Bằng 1 khi đếm = 0.
  - `pre_last`: Bằng 1 khi đếm = 1.
  - `count[6:0]`: Giá trị hiện tại.
- **Mô phỏng**
![image](https://github.com/user-attachments/assets/2161a889-f0ed-4b8a-832b-45d635d678b4)

---

### 5. `7-Segment Display Controller`
- **Chức năng**: Chuyển đổi `count_value` thành mã điều khiển LED 7 đoạn để hiển thị 2 chữ số.
- **Ngõ vào**: `count_value`
- **Ngõ ra**: `display_led[15:0]` (gồm 2 chữ số × 7 đoạn + 2 chấm)
- **Mô phỏng**
![image](https://github.com/user-attachments/assets/2496a4e7-ac78-4198-bc88-d5f0698e433a)
---

## 🧪 Kiểm Thử (Testbench)

Các tệp testbench có sẵn để mô phỏng hoạt động của từng module:

- ✅ `traffic_fsm_tb.v`: Mô phỏng FSM chuyển pha đèn và kiểm tra đầu ra `light` và `light_cnt_init`.
- ✅ `light_counter_tb.v`: Kiểm tra bộ đếm từng pha đèn.
- ✅ `second_counter_tb.v`: Kiểm tra đếm từ 99 → 0 và tín hiệu `last`, `pre_last`.

---

## 📐 Mô tả Ngõ Vào/Ra của Top Module

| Tên Tín Hiệu     | Hướng      | Độ Rộng | Mô tả                                  |
|------------------|------------|---------|-----------------------------------------|
| `clk`            | input      | 1       | Xung đồng hồ hệ thống 10MHz             |
| `rst_n`          | input      | 1       | Tín hiệu reset bất đồng bộ, mức thấp    |
| `en`             | input      | 1       | Tín hiệu kích hoạt hệ thống             |
| `red_light`      | output     | 1       | Điều khiển đèn đỏ                       |
| `yellow_light`   | output     | 1       | Điều khiển đèn vàng                     |
| `green_light`    | output     | 1       | Điều khiển đèn xanh                     |
| `display_led`    | output     | 16      | Hiển thị LED 7 đoạn (2 chữ số)          |

---

## 🛠️ Thông Số Hệ Thống

- **Tần số xung chính**: 10MHz  
- **Thời gian đèn đỏ**: 18 giây  
- **Thời gian đèn vàng**: 3 giây  
- **Thời gian đèn xanh**: 15 giây  
- **Hiển thị**: LED 7 đoạn gồm 2 chữ số

---

## 🧠 Nguyên Lý Hoạt Động

1. Khi khởi động, hệ thống bắt đầu ở trạng thái **đèn đỏ** (18 giây).
2. Sau đó chuyển sang **đèn xanh** (15 giây).
3. Rồi đến **đèn vàng** (3 giây).
4. Chu trình lặp lại liên tục.
5. Mỗi pha đèn sẽ hiển thị thời gian còn lại trên LED 7 đoạn.

---

## 💡 Ghi Chú

- Hệ thống hoạt động hoàn toàn đồng bộ với xung 1Hz.
- Việc chuyển pha đèn được điều khiển bằng FSM dựa trên tín hiệu thời gian.
- Việc hiển thị dùng chuyển đổi nhị phân → LED 7 đoạn.

---

## 📷 Sơ Đồ Khối và kết quả
Sơ đồ khối
![image](https://github.com/user-attachments/assets/973ac5c3-eb01-422d-bff7-e7d481a996d0)
Kết quả              
![image](https://github.com/user-attachments/assets/455016a8-a671-4dea-b731-4ba1f566e2d8)
![image](https://github.com/user-attachments/assets/015c022b-0fec-413f-9ad1-d49aa386a69a)

---

## 🔁 Hướng Phát Triển Tương Lai

- Thêm chức năng điều khiển vạch qua đường cho người đi bộ.
- Hỗ trợ chế độ ban đêm (chớp vàng).
- Tự động điều chỉnh thời gian dựa trên cảm biến lưu lượng.
- Viết testbench và script tự động kiểm thử toàn hệ thống.

---

# 📁 Dự án: TrafficLight_RTL_v2
