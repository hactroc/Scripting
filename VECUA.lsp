;;; ==========================================================================
;;; MODULE: PARAMETRIC DESIGN - TẠO SINH CỬA NHÔM KÍNH
;;; LỆNH KÍCH HOẠT: VECUA
;;; DỰ ÁN: NỘI THẤT HÙNG VƯƠNG
;;; TÁC GIẢ: NGUYỄN TRỌNG TUỆ - LỚP: CNTT B
;;; GVHD: NGÔ VĂN NAM
;;; ==========================================================================

;; Hàm phụ trợ: Tạo đường Polyline khép kín (Hình chữ nhật)
(defun tao-hcn (p1 p3)
  (entmake (list (cons 0 "LWPOLYLINE")
                 (cons 100 "AcDbEntity")
                 (cons 100 "AcDbPolyline")
                 (cons 90 4)   ; Số lượng đỉnh
                 (cons 70 1)   ; Thuộc tính khép kín (Closed)
                 (cons 10 (list (car p1) (cadr p1)))
                 (cons 10 (list (car p3) (cadr p1)))
                 (cons 10 (list (car p3) (cadr p3)))
                 (cons 10 (list (car p1) (cadr p3)))))
)

;; Hàm phụ trợ: Tạo đường thẳng
(defun tao-duong-thang (p1 p2)
  (entmake (list (cons 0 "LINE") (cons 10 p1) (cons 11 p2)))
)

;; Hàm phụ trợ: Tạo Text ghi chú
(defun tao-text (pt noi_dung chieu_cao)
  (entmake (list (cons 0 "TEXT")
                 (cons 10 pt)
                 (cons 11 pt)
                 (cons 40 chieu_cao)
                 (cons 1 noi_dung)
                 (cons 72 1) ; Căn giữa (Center)
                 (cons 73 2))) ; Căn giữa theo trục Y (Middle)
)

(defun c:VECUA (/ pt w h k_bao k_canh p1 p3 in1_p1 in1_p3 in2_p1 in2_p3 text_pt)
  (prompt "\n[He thong Hung Vuong] - Cong cu tao sinh ban ve Cua Kinh")
  
  ;; BƯỚC 1: LẤY THAM SỐ (Hỗ trợ nhập nhanh kích thước chuẩn)
  (if (not (setq pt (getpoint "\nChon diem goc (Goc duoi cung ben trai): "))) (quit))
  (setq ten_cua (getstring T "\nNhap ky hieu cua (VD: D7): "))
  
  (setq w (getreal "\nNhap chieu rong cua (mm) <Mac dinh: 930>: "))
  (if (not w) (setq w 930.0))
  
  (setq h (getreal "\nNhap chieu cao cua (mm) <Mac dinh: 2200>: "))
  (if (not h) (setq h 2200.0))
  
  ;; Hằng số kết cấu nhôm (Có thể tùy chỉnh theo hệ nhôm Xingfa/Việt Pháp)
  (setq k_bao 50.0)  ; Bề rộng khung bao tường
  (setq k_canh 80.0) ; Bề rộng bản nhôm cánh cửa
  
  ;; BƯỚC 2: TÍNH TOÁN TỌA ĐỘ MA TRẬN
  ;; Khung bao ngoài cùng
  (setq p1 pt)
  (setq p3 (list (+ (car p1) w) (+ (cadr p1) h)))
  
  ;; Khung cánh cửa (Offset vào trong 50mm)
  (setq in1_p1 (list (+ (car p1) k_bao) (+ (cadr p1) k_bao)))
  (setq in1_p3 (list (- (car p3) k_bao) (- (cadr p3) k_bao)))
  
  ;; Lõi kính (Offset tiếp vào trong 80mm)
  (setq in2_p1 (list (+ (car in1_p1) k_canh) (+ (cadr in1_p1) k_canh)))
  (setq in2_p3 (list (- (car in1_p3) k_canh) (- (cadr in1_p3) k_canh)))
  
  ;; BƯỚC 3: KIẾN TẠO HÌNH HỌC (RENDER GEOMETRY)
  (tao-hcn p1 p3)         ; Vẽ khung bao
  (tao-hcn in1_p1 in1_p3) ; Vẽ khung cánh
  (tao-hcn in2_p1 in2_p3) ; Vẽ lõi kính
  
  ;; Vẽ ký hiệu vách kính (Đường chéo)
  (tao-duong-thang in2_p1 in2_p3)
  (tao-duong-thang (list (car in2_p1) (cadr in2_p3)) (list (car in2_p3) (cadr in2_p1)))
  
  ;; BƯỚC 4: TỰ ĐỘNG GẮN NHÃN (AUTO-LABELING)
  ;; Tính toán điểm chính giữa bên dưới cửa để đặt Text
  (setq text_pt (list (+ (car p1) (/ w 2.0)) (- (cadr p1) 150.0)))
  (tao-text text_pt (strcat "C\U+1EECA " ten_cua) 100.0)
  
  (princ (strcat "\n[Thanh cong] Da tao sinh Cua kinh kich thuoc: " (rtos w 2 0) "x" (rtos h 2 0)))
  (princ)
)