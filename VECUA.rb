# ==========================================================================
# MODULE: SKETCHUP RUBY API - TẠO CỬA NHÔM KÍNH
# DỰ ÁN: NỘI THẤT HÙNG VƯƠNG
# TÁC GIẢ: NGUYỄN TRỌNG TUỆ - LỚP: CNTT B
# GVHD: NGÔ VĂN NAM
# TÍNH NĂNG: Tạo cửa nhôm kính với số lượng cánh
# ==========================================================================

require 'sketchup.rb'
module HungVuong_BIM
  module SmartDoors
    
    def self.duc_thanh_vat_lieu(ents, x, y, z, w, h, d, mat_name="Aluminum")
      sub_group = ents.add_group
      s_ents = sub_group.entities
      
      pt1 = Geom::Point3d.new(x, y, z)
      pt2 = Geom::Point3d.new(x + w, y, z)
      pt3 = Geom::Point3d.new(x + w, y + h, z)
      pt4 = Geom::Point3d.new(x, y + h, z)
      
      face = s_ents.add_face(pt1, pt2, pt3, pt4)
      
      push_dist = face.normal.z > 0 ? d : -d
      face.pushpull(push_dist)
      
      color = (mat_name == "Glass") ? "LightBlue" : "DimGray"
      sub_group.material = color
    end

    def self.tao_canh_cua(ents, x_start, y_start, z_start, leaf_w, leaf_h)
      f_w = 80.0 / 25.4  
      f_d = 40.0 / 25.4  
      gl_thk = 10.0 / 25.4 
      
      duc_thanh_vat_lieu(ents, x_start, y_start, z_start, f_w, leaf_h, f_d) 
      duc_thanh_vat_lieu(ents, x_start + leaf_w - f_w, y_start, z_start, f_w, leaf_h, f_d) 
      duc_thanh_vat_lieu(ents, x_start + f_w, y_start, z_start, leaf_w - 2*f_w, f_w, f_d) 
      duc_thanh_vat_lieu(ents, x_start + f_w, y_start + leaf_h - f_w, z_start, leaf_w - 2*f_w, f_w, f_d) 
      
      z_glass = z_start + (f_d - gl_thk) / 2.0
      duc_thanh_vat_lieu(ents, x_start + f_w, y_start + f_w, z_glass, leaf_w - 2*f_w, leaf_h - 2*f_w, gl_thk, "Glass")
    end

    def self.generate
      model = Sketchup.active_model
      
      prompts = ["Chiều rộng tổng (mm):", "Chiều cao tổng (mm):", "Số lượng cánh (1, 2, 4):", "Có ô thoáng bên trên? (Yes/No):", "Cao độ ô thoáng (mm):"]
      defaults = ["2400", "2800", "4", "Yes", "500"]
      drop_downs = ["", "", "1|2|4", "Yes|No", ""]
      
      input = UI.inputbox(prompts, defaults, drop_downs, "Hệ Thống Đúc Cửa Thông Minh")
      return unless input
      
      total_w = input[0].to_f / 25.4
      total_h = input[1].to_f / 25.4
      num_leaves = input[2].to_i
      has_transom = (input[3] == "Yes")
      transom_h = input[4].to_f / 25.4
      
      k_bao_w = 50.0 / 25.4 
      k_bao_d = 100.0 / 25.4 
      
      model.start_operation('HV - Đúc Cửa Chống Vỡ', true)
      
      begin
        uid = Time.now.to_i
        comp_def = model.definitions.add("HV_CuaNhom_#{uid}")
        
        # ---------------------------------------------------------
        # FIX BUG TẠI ĐÂY: Dùng số nguyên (Integer 2) thay cho hằng số chữ
        # ---------------------------------------------------------
        comp_def.behavior.is2d = true
        comp_def.behavior.snapto = 2 # 2 = Snap to Vertical (Bám tường dọc)
        
        gents = comp_def.entities
        
        duc_thanh_vat_lieu(gents, 0, 0, 0, k_bao_w, total_h, k_bao_d) 
        duc_thanh_vat_lieu(gents, total_w - k_bao_w, 0, 0, k_bao_w, total_h, k_bao_d) 
        duc_thanh_vat_lieu(gents, k_bao_w, total_h - k_bao_w, 0, total_w - 2*k_bao_w, k_bao_w, k_bao_d) 
        
        clear_w = total_w - 2 * k_bao_w
        door_h = total_h - k_bao_w
        z_door = (k_bao_d - (40.0/25.4)) / 2.0 
        
        if has_transom
          y_do_ngang = total_h - transom_h - k_bao_w
          duc_thanh_vat_lieu(gents, k_bao_w, y_do_ngang, 0, clear_w, k_bao_w, k_bao_d) 
          
          z_glass = (k_bao_d - (10.0/25.4)) / 2.0
          duc_thanh_vat_lieu(gents, k_bao_w, y_do_ngang + k_bao_w, z_glass, clear_w, transom_h - k_bao_w, 10.0/25.4, "Glass")
          
          door_h = y_do_ngang 
        end
        
        leaf_w = clear_w / num_leaves.to_f
        (0...num_leaves).each do |i|
          x_offset = k_bao_w + (i * leaf_w)
          tao_canh_cua(gents, x_offset, 0, z_door, leaf_w, door_h)
        end
        
      rescue => e
        UI.messagebox("Lỗi tạo hình: #{e.message}")
        model.abort_operation
        return
      end
      
      model.commit_operation
      model.place_component(comp_def, false)
    end
  end
end

unless file_loaded?("HV_SmartDoors_Menu")
  menu = UI.menu('Plugins')
  menu.add_item('HV - Đúc Cửa (Gắn Trực Tiếp Tường)') {
    HungVuong_BIM::SmartDoors.generate
  }
  file_loaded("HV_SmartDoors_Menu")
end