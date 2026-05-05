# Scripting
1. Cách cài đặt VECUA.lsp vào AutoCAD
Vì đây là file AutoLISP, bạn cần thực hiện các bước sau để AutoCAD nhận diện được lệnh:

Bước 1: Mở AutoCAD và bản vẽ bạn đang thực hiện.

Bước 2: Dùng lệnh APPLOAD:

Gõ AP (hoặc APPLOAD) rồi nhấn Enter.

Tìm đến thư mục chứa file VECUA.lsp.  

Nhấn Load. Nếu bạn muốn lệnh này tự động load mỗi khi mở AutoCAD, hãy nhấn vào biểu tượng Contents (hình cái cặp) trong mục Startup Suite và thêm file này vào đó.

Bước 3: Kích hoạt lệnh:

Tại dòng Command Line, gõ lệnh: VECUA.  

Sau đó chỉ việc chọn điểm đặt, nhập ký hiệu cửa và kích thước theo yêu cầu của hệ thống.  

2. Cách cài đặt VECUA.rb vào SketchUp
Đây là file Ruby API, nó cần được đặt đúng vào "trái tim" của các Plugin trong SketchUp.  

Bước 1: Tìm thư mục Plugins của SketchUp:

Đường dẫn thông thường (thay [Năm] bằng phiên bản bạn dùng, ví dụ 2022):
C:\Users\[Tên_User]\AppData\Roaming\SketchUp\SketchUp [Năm]\SketchUp\Plugins

Bước 2: Sao chép file:

Copy file VECUA.rb và dán trực tiếp vào thư mục này.  

Bước 3: Khởi động lại SketchUp:

Sau khi mở lại phần mềm, bạn nhìn lên thanh menu trên cùng.

Vào mục Extensions (Mở rộng) hoặc Plugins.

Chọn mục: HV - Đúc Cửa (Gắn Trực Tiếp Tường).  

Bước 4: Nhập thông số: Hệ thống sẽ hiện một bảng (Input Box) để bạn nhập chiều rộng, chiều cao và số cánh.
