-- Tên : Lê Quốc Trung
-- Lớp : 12_ĐH_CNTT4
-- MSSV: 1250080215


-- Tao bang KHOA
CREATE TABLE KHOA (
    Makhoa    VARCHAR2(10)  PRIMARY KEY,
    Tenkhoa   VARCHAR2(100) NOT NULL,
    Dienthoai VARCHAR2(15)
);

-- Tao bang LOP
CREATE TABLE LOP (
    Malop      VARCHAR2(10)  PRIMARY KEY,
    Tenlop     VARCHAR2(100) NOT NULL,
    Khoa       VARCHAR2(50),
    Hedt       VARCHAR2(50),
    Namnhaphoc NUMBER(4),
    Makhoa     VARCHAR2(10),
    CONSTRAINT fk_lop_khoa FOREIGN KEY (Makhoa) REFERENCES KHOA(Makhoa)
);

-- Du lieu mau
INSERT INTO KHOA VALUES ('CNTT', 'Cong Nghe Thong Tin', '0281234567');
INSERT INTO KHOA VALUES ('KTPM', 'Ky Thuat Phan Mem',   '0281234568');
INSERT INTO KHOA VALUES ('HTTT', 'He Thong Thong Tin',  '0281234569');
COMMIT;

-- ============================================================
-- BAI TAP 1
-- (In thong bao ra man hinh)
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_Them_Khoa_1 (
    p_makhoa    IN KHOA.Makhoa%TYPE,
    p_tenkhoa   IN KHOA.Tenkhoa%TYPE,
    p_dienthoai IN KHOA.Dienthoai%TYPE
) AS
    v_dem NUMBER := 0;
BEGIN
    -- Kiem tra ten khoa da ton tai chua
    SELECT COUNT(*) INTO v_dem
    FROM KHOA
    WHERE UPPER(Tenkhoa) = UPPER(p_tenkhoa);

    IF v_dem > 0 THEN
        DBMS_OUTPUT.PUT_LINE('THONG BAO: Ten khoa "' || p_tenkhoa || '" da ton tai trong he thong!');
    ELSE
        INSERT INTO KHOA (Makhoa, Tenkhoa, Dienthoai)
        VALUES (p_makhoa, p_tenkhoa, p_dienthoai);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('THANH CONG: Da them khoa "' || p_tenkhoa || '" vao he thong.');
    END IF;
END SP_Them_Khoa_1;
/

-- TEST BAI TAP 1
SET SERVEROUTPUT ON;

-- Truong hop 1: Ten khoa CHUA ton tai => them thanh cong
BEGIN
    SP_Them_Khoa_1('DTVT', 'Dien Tu Vien Thong', '0281234570');
END;
/

-- Truong hop 2: Ten khoa DA ton tai => thong bao loi
BEGIN
    SP_Them_Khoa_1('CNTT2', 'Cong Nghe Thong Tin', '0281234571');
END;
/


-- ============================================================
-- BAI TAP 2
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_Them_Lop_1 (
    p_malop      IN LOP.Malop%TYPE,
    p_tenlop     IN LOP.Tenlop%TYPE,
    p_khoa       IN LOP.Khoa%TYPE,
    p_hedt       IN LOP.Hedt%TYPE,
    p_namnhaphoc IN LOP.Namnhaphoc%TYPE,
    p_makhoa     IN LOP.Makhoa%TYPE
) AS
    v_dem_lop    NUMBER := 0;
    v_dem_khoa   NUMBER := 0;
BEGIN
    -- Kiem tra ten lop da ton tai chua
    SELECT COUNT(*) INTO v_dem_lop
    FROM LOP
    WHERE UPPER(Tenlop) = UPPER(p_tenlop);

    IF v_dem_lop > 0 THEN
        DBMS_OUTPUT.PUT_LINE('THONG BAO: Ten lop "' || p_tenlop || '" da ton tai!');
        RETURN;
    END IF;

    -- Kiem tra makhoa co ton tai trong bang KHOA khong
    SELECT COUNT(*) INTO v_dem_khoa
    FROM KHOA
    WHERE UPPER(Makhoa) = UPPER(p_makhoa);

    IF v_dem_khoa = 0 THEN
        DBMS_OUTPUT.PUT_LINE('THONG BAO: Ma khoa "' || p_makhoa || '" khong ton tai trong he thong!');
        RETURN;
    END IF;

    -- Du dieu kien: them lop
    INSERT INTO LOP (Malop, Tenlop, Khoa, Hedt, Namnhaphoc, Makhoa)
    VALUES (p_malop, p_tenlop, p_khoa, p_hedt, p_namnhaphoc, p_makhoa);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('THANH CONG: Da them lop "' || p_tenlop || '" vao he thong.');
END SP_Them_Lop_1;
/

-- TEST BAI TAP 2
SET SERVEROUTPUT ON;

-- Truong hop 1: Du dieu kien => them thanh cong
BEGIN
    SP_Them_Lop_1('CNTT01', 'Lap Trinh Java', '1', 'Chinh quy', 2023, 'CNTT');
END;
/

-- Truong hop 2: Ten lop da ton tai
BEGIN
    SP_Them_Lop_1('CNTT02', 'Lap Trinh Java', '1', 'Chinh quy', 2023, 'CNTT');
END;
/

-- Truong hop 3: Makhoa khong ton tai
BEGIN
    SP_Them_Lop_1('XYZ01', 'Lop Ky Thuat', '1', 'Chinh quy', 2023, 'XYZK');
END;
/


-- ============================================================
-- BAI TAP 3
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_Them_Khoa_2 (
    p_makhoa    IN  KHOA.Makhoa%TYPE,
    p_tenkhoa   IN  KHOA.Tenkhoa%TYPE,
    p_dienthoai IN  KHOA.Dienthoai%TYPE,
    p_ketqua    OUT NUMBER
) AS
    v_dem NUMBER := 0;
BEGIN
    -- Kiem tra ten khoa da ton tai chua
    SELECT COUNT(*) INTO v_dem
    FROM KHOA
    WHERE UPPER(Tenkhoa) = UPPER(p_tenkhoa);

    IF v_dem > 0 THEN
        p_ketqua := 0; -- Ten khoa da ton tai
    ELSE
        INSERT INTO KHOA (Makhoa, Tenkhoa, Dienthoai)
        VALUES (p_makhoa, p_tenkhoa, p_dienthoai);
        COMMIT;
        p_ketqua := 1; -- Them thanh cong
    END IF;
END SP_Them_Khoa_2;
/

-- TEST BAI TAP 3
SET SERVEROUTPUT ON;

-- Truong hop 1: Ten khoa CHUA ton tai => them thanh cong, ket qua = 1
DECLARE
    v_kq NUMBER;
BEGIN
    SP_Them_Khoa_2('TCKT', 'Tai Chinh Ke Toan', '0281234572', v_kq);
    IF v_kq = 1 THEN
        DBMS_OUTPUT.PUT_LINE('THANH CONG: Them khoa thanh cong. Ma ket qua: ' || v_kq);
    ELSE
        DBMS_OUTPUT.PUT_LINE('THAT BAI: Ten khoa da ton tai. Ma ket qua: ' || v_kq);
    END IF;
END;
/

-- Truong hop 2: Ten khoa DA ton tai => tra ve 0
DECLARE
    v_kq NUMBER;
BEGIN
    SP_Them_Khoa_2('CNTT3', 'Cong Nghe Thong Tin', '0281234573', v_kq);
    IF v_kq = 1 THEN
        DBMS_OUTPUT.PUT_LINE('THANH CONG: Them khoa thanh cong. Ma ket qua: ' || v_kq);
    ELSE
        DBMS_OUTPUT.PUT_LINE('THAT BAI: Ten khoa da ton tai. Ma ket qua: ' || v_kq);
    END IF;
END;
/


-- ============================================================
-- BAI TAP 4
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_Them_Lop_2 (
    p_malop      IN  LOP.Malop%TYPE,
    p_tenlop     IN  LOP.Tenlop%TYPE,
    p_khoa       IN  LOP.Khoa%TYPE,
    p_hedt       IN  LOP.Hedt%TYPE,
    p_namnhaphoc IN  LOP.Namnhaphoc%TYPE,
    p_makhoa     IN  LOP.Makhoa%TYPE,
    p_ketqua     OUT NUMBER
) AS
    v_dem_lop    NUMBER := 0;
    v_dem_khoa   NUMBER := 0;
BEGIN
    -- Kiem tra ten lop da ton tai chua
    SELECT COUNT(*) INTO v_dem_lop
    FROM LOP
    WHERE UPPER(Tenlop) = UPPER(p_tenlop);

    IF v_dem_lop > 0 THEN
        p_ketqua := 0; -- Ten lop da ton tai
        RETURN;
    END IF;

    -- Kiem tra makhoa co trong bang KHOA khong
    SELECT COUNT(*) INTO v_dem_khoa
    FROM KHOA
    WHERE UPPER(Makhoa) = UPPER(p_makhoa);

    IF v_dem_khoa = 0 THEN
        p_ketqua := 1; -- Makhoa khong ton tai
        RETURN;
    END IF;

    -- Du dieu kien: them lop
    INSERT INTO LOP (Malop, Tenlop, Khoa, Hedt, Namnhaphoc, Makhoa)
    VALUES (p_malop, p_tenlop, p_khoa, p_hedt, p_namnhaphoc, p_makhoa);
    COMMIT;
    p_ketqua := 2; -- Them thanh cong
END SP_Them_Lop_2;
/

-- TEST BAI TAP 4
SET SERVEROUTPUT ON;

-- Truong hop 1: Du dieu kien => ket qua = 2
DECLARE
    v_kq NUMBER;
BEGIN
    SP_Them_Lop_2('CNTT03', 'Phat Trien Ung Dung Web', '2', 'Chinh quy', 2024, 'CNTT', v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq ||
        CASE v_kq
            WHEN 0 THEN ' - Ten lop da ton tai'
            WHEN 1 THEN ' - Ma khoa khong ton tai'
            WHEN 2 THEN ' - Them lop thanh cong'
        END);
END;
/

-- Truong hop 2: Ten lop da ton tai => ket qua = 0
DECLARE
    v_kq NUMBER;
BEGIN
    SP_Them_Lop_2('CNTT04', 'Lap Trinh Java', '1', 'Chinh quy', 2024, 'CNTT', v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq ||
        CASE v_kq
            WHEN 0 THEN ' - Ten lop da ton tai'
            WHEN 1 THEN ' - Ma khoa khong ton tai'
            WHEN 2 THEN ' - Them lop thanh cong'
        END);
END;
/

-- Truong hop 3: Makhoa khong ton tai => ket qua = 1
DECLARE
    v_kq NUMBER;
BEGIN
    SP_Them_Lop_2('XYZ02', 'Lop Vat Ly', '1', 'Chinh quy', 2024, 'VATLY', v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq ||
        CASE v_kq
            WHEN 0 THEN ' - Ten lop da ton tai'
            WHEN 1 THEN ' - Ma khoa khong ton tai'
            WHEN 2 THEN ' - Them lop thanh cong'
        END);
END;
/


-- ============================================================
-- PHIEU BAI TAP 2 - CSDL QLNV
-- ============================================================

-- Tao bang tblChucVu
CREATE TABLE tblChucVu (
    MaCV  VARCHAR2(10)  PRIMARY KEY,
    TenCV VARCHAR2(100) NOT NULL
);

-- Tao bang tblNhanVien
CREATE TABLE tblNhanVien (
    MaNV       VARCHAR2(10)   PRIMARY KEY,
    MaCV       VARCHAR2(10)   NOT NULL,
    TenNV      VARCHAR2(100)  NOT NULL,
    NgaySinh   DATE,
    LuongCanBan NUMBER(12, 2),
    NgayCong   NUMBER(3),
    PhuCap     NUMBER(12, 2),
    CONSTRAINT fk_nv_chucvu FOREIGN KEY (MaCV) REFERENCES tblChucVu(MaCV)
);

-- Du lieu mau tblChucVu (it nhat 4 chuc vu)
INSERT INTO tblChucVu VALUES ('GD',   'Giam Doc');
INSERT INTO tblChucVu VALUES ('PGD',  'Pho Giam Doc');
INSERT INTO tblChucVu VALUES ('TP',   'Truong Phong');
INSERT INTO tblChucVu VALUES ('NV',   'Nhan Vien');
INSERT INTO tblChucVu VALUES ('KT',   'Ke Toan');
COMMIT;

-- Du lieu mau tblNhanVien (it nhat 3 nhan vien)
INSERT INTO tblNhanVien VALUES ('NV001', 'GD',  'Nguyen Van An',   TO_DATE('15/03/1975','DD/MM/YYYY'), 20000000, 26, 5000000);
INSERT INTO tblNhanVien VALUES ('NV002', 'TP',  'Tran Thi Binh',   TO_DATE('20/07/1985','DD/MM/YYYY'), 12000000, 24, 2000000);
INSERT INTO tblNhanVien VALUES ('NV003', 'NV',  'Le Van Cuong',    TO_DATE('10/01/1992','DD/MM/YYYY'),  8000000, 22, 1000000);
INSERT INTO tblNhanVien VALUES ('NV004', 'KT',  'Pham Thi Dung',   TO_DATE('05/09/1988','DD/MM/YYYY'), 10000000, 25, 1500000);
COMMIT;


-- ============================================================
-- PHIEU BAI TAP 2 - CAU a
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_Them_Nhan_Vien (
    p_manv       IN tblNhanVien.MaNV%TYPE,
    p_macv       IN tblNhanVien.MaCV%TYPE,
    p_tennv      IN tblNhanVien.TenNV%TYPE,
    p_ngaysinh   IN tblNhanVien.NgaySinh%TYPE,
    p_luongcb    IN tblNhanVien.LuongCanBan%TYPE,
    p_ngaycong   IN tblNhanVien.NgayCong%TYPE,
    p_phucap     IN tblNhanVien.PhuCap%TYPE
) AS
    v_dem_cv NUMBER := 0;
BEGIN
    -- Kiem tra MaCV co ton tai trong tblChucVu khong
    SELECT COUNT(*) INTO v_dem_cv
    FROM tblChucVu
    WHERE MaCV = p_macv;

    IF v_dem_cv = 0 THEN
        DBMS_OUTPUT.PUT_LINE('THONG BAO: Ma chuc vu "' || p_macv || '" khong ton tai!');
    ELSE
        INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
        VALUES (p_manv, p_macv, p_tennv, p_ngaysinh, p_luongcb, p_ngaycong, p_phucap);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('THANH CONG: Da them nhan vien "' || p_tennv || '".');
    END IF;
END SP_Them_Nhan_Vien;
/

-- TEST SP_Them_Nhan_Vien
SET SERVEROUTPUT ON;

-- Truong hop 1: MaCV hop le => them thanh cong
BEGIN
    SP_Them_Nhan_Vien('NV005', 'NV', 'Hoang Van Em',
        TO_DATE('12/06/1995','DD/MM/YYYY'), 7500000, 20, 800000);
END;
/

-- Truong hop 2: MaCV khong ton tai => thong bao loi
BEGIN
    SP_Them_Nhan_Vien('NV006', 'BGD', 'Vo Thi Phuong',
        TO_DATE('18/11/1990','DD/MM/YYYY'), 9000000, 23, 1200000);
END;
/


-- ============================================================
-- PHIEU BAI TAP 2 - CAU b
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_CapNhat_Nhan_Vien (
    p_manv       IN tblNhanVien.MaNV%TYPE,
    p_macv       IN tblNhanVien.MaCV%TYPE,
    p_tennv      IN tblNhanVien.TenNV%TYPE,
    p_ngaysinh   IN tblNhanVien.NgaySinh%TYPE,
    p_luongcb    IN tblNhanVien.LuongCanBan%TYPE,
    p_ngaycong   IN tblNhanVien.NgayCong%TYPE,
    p_phucap     IN tblNhanVien.PhuCap%TYPE
) AS
    v_dem_cv   NUMBER := 0;
    v_dem_nv   NUMBER := 0;
BEGIN
    -- Kiem tra nhan vien co ton tai khong
    SELECT COUNT(*) INTO v_dem_nv
    FROM tblNhanVien
    WHERE MaNV = p_manv;

    IF v_dem_nv = 0 THEN
        DBMS_OUTPUT.PUT_LINE('THONG BAO: Nhan vien "' || p_manv || '" khong ton tai!');
        RETURN;
    END IF;

    -- Kiem tra MaCV co ton tai trong tblChucVu khong
    SELECT COUNT(*) INTO v_dem_cv
    FROM tblChucVu
    WHERE MaCV = p_macv;

    IF v_dem_cv = 0 THEN
        DBMS_OUTPUT.PUT_LINE('THONG BAO: Ma chuc vu "' || p_macv || '" khong ton tai!');
    ELSE
        -- Cap nhat (khong cap nhat MaNV)
        UPDATE tblNhanVien
        SET MaCV       = p_macv,
            TenNV      = p_tennv,
            NgaySinh   = p_ngaysinh,
            LuongCanBan = p_luongcb,
            NgayCong   = p_ngaycong,
            PhuCap     = p_phucap
        WHERE MaNV = p_manv;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('THANH CONG: Da cap nhat thong tin nhan vien "' || p_manv || '".');
    END IF;
END SP_CapNhat_Nhan_Vien;
/

-- TEST SP_CapNhat_Nhan_Vien
SET SERVEROUTPUT ON;

-- Truong hop 1: MaCV hop le, MaNV ton tai => cap nhat thanh cong
BEGIN
    SP_CapNhat_Nhan_Vien('NV003', 'TP', 'Le Van Cuong Updated',
        TO_DATE('10/01/1992','DD/MM/YYYY'), 13000000, 25, 2500000);
END;
/

-- Truong hop 2: MaCV khong ton tai => thong bao
BEGIN
    SP_CapNhat_Nhan_Vien('NV002', 'XXX', 'Tran Thi Binh',
        TO_DATE('20/07/1985','DD/MM/YYYY'), 12000000, 24, 2000000);
END;
/


-- ============================================================
-- PHIEU BAI TAP 2 - CAU c
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_LuongLN AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('====================================================');
    DBMS_OUTPUT.PUT_LINE('       BANG LUONG NHAN VIEN                        ');
    DBMS_OUTPUT.PUT_LINE('====================================================');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('Ma NV', 8) || ' | ' ||
        RPAD('Ho Ten', 25) || ' | ' ||
        RPAD('Chuc Vu', 10) || ' | ' ||
        LPAD('Luong', 15)
    );
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

    FOR rec IN (
        SELECT nv.MaNV,
               nv.TenNV,
               cv.TenCV,
               (nv.LuongCanBan * nv.NgayCong + nv.PhuCap) AS Luong
        FROM tblNhanVien nv
        JOIN tblChucVu cv ON nv.MaCV = cv.MaCV
        ORDER BY nv.MaNV
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(rec.MaNV, 8) || ' | ' ||
            RPAD(rec.TenNV, 25) || ' | ' ||
            RPAD(rec.TenCV, 10) || ' | ' ||
            LPAD(TO_CHAR(rec.Luong, 'FM999,999,999,990'), 15)
        );
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('====================================================');
END SP_LuongLN;
/

-- TEST SP_LuongLN
SET SERVEROUTPUT ON;
BEGIN
    SP_LuongLN();
END;
/


-- ============================================================
-- PHIEU BAI TAP 3 - CSDL QLNV (dung lai cau truc tu Phieu 2)
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_them_nhan_vien1 (
    p_manv       IN  tblNhanVien.MaNV%TYPE,
    p_macv       IN  tblNhanVien.MaCV%TYPE,
    p_tennv      IN  tblNhanVien.TenNV%TYPE,
    p_ngaysinh   IN  tblNhanVien.NgaySinh%TYPE,
    p_luongcb    IN  tblNhanVien.LuongCanBan%TYPE,
    p_ngaycong   IN  tblNhanVien.NgayCong%TYPE,
    p_phucap     IN  tblNhanVien.PhuCap%TYPE,
    p_ketqua     OUT NUMBER
) AS
    v_dem_cv NUMBER := 0;
BEGIN
    -- Kiem tra MaCV co ton tai trong tblChucVu khong
    SELECT COUNT(*) INTO v_dem_cv
    FROM tblChucVu
    WHERE MaCV = p_macv;

    IF v_dem_cv = 0 THEN
        p_ketqua := 0; -- MaCV chua ton tai
    ELSE
        INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
        VALUES (p_manv, p_macv, p_tennv, p_ngaysinh, p_luongcb, p_ngaycong, p_phucap);
        COMMIT;
        p_ketqua := 1; -- Them thanh cong
    END IF;
END sp_them_nhan_vien1;
/

-- TEST Cau 1
SET SERVEROUTPUT ON;

-- Truong hop 1: MaCV ton tai => them thanh cong, ket qua = 1
DECLARE
    v_kq NUMBER;
BEGIN
    sp_them_nhan_vien1('NV007', 'KT', 'Bui Van Giang',
        TO_DATE('22/03/1993','DD/MM/YYYY'), 9500000, 23, 1100000, v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq ||
        CASE v_kq WHEN 0 THEN ' - Ma chuc vu chua ton tai' ELSE ' - Them nhan vien thanh cong' END);
END;
/

-- Truong hop 2: MaCV khong ton tai => ket qua = 0
DECLARE
    v_kq NUMBER;
BEGIN
    sp_them_nhan_vien1('NV008', 'TBGD', 'Dinh Thi Huong',
        TO_DATE('05/12/1991','DD/MM/YYYY'), 11000000, 24, 1800000, v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq ||
        CASE v_kq WHEN 0 THEN ' - Ma chuc vu chua ton tai' ELSE ' - Them nhan vien thanh cong' END);
END;
/


-- ============================================================
-- PHIEU BAI TAP 3 - CAU 2
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_them_nhan_vien2 (
    p_manv       IN  tblNhanVien.MaNV%TYPE,
    p_macv       IN  tblNhanVien.MaCV%TYPE,
    p_tennv      IN  tblNhanVien.TenNV%TYPE,
    p_ngaysinh   IN  tblNhanVien.NgaySinh%TYPE,
    p_luongcb    IN  tblNhanVien.LuongCanBan%TYPE,
    p_ngaycong   IN  tblNhanVien.NgayCong%TYPE,
    p_phucap     IN  tblNhanVien.PhuCap%TYPE,
    p_ketqua     OUT NUMBER
) AS
    v_dem_nv   NUMBER := 0;
    v_dem_cv   NUMBER := 0;
BEGIN
    -- Kiem tra MaNV da ton tai chua
    SELECT COUNT(*) INTO v_dem_nv
    FROM tblNhanVien
    WHERE MaNV = p_manv;

    IF v_dem_nv > 0 THEN
        p_ketqua := 0; -- MaNV da ton tai
        RETURN;
    END IF;

    -- Kiem tra MaCV co ton tai trong tblChucVu khong
    SELECT COUNT(*) INTO v_dem_cv
    FROM tblChucVu
    WHERE MaCV = p_macv;

    IF v_dem_cv = 0 THEN
        p_ketqua := 1; -- MaCV chua ton tai
        RETURN;
    END IF;

    -- Du dieu kien: them nhan vien
    INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
    VALUES (p_manv, p_macv, p_tennv, p_ngaysinh, p_luongcb, p_ngaycong, p_phucap);
    COMMIT;
    p_ketqua := 2; -- Them thanh cong
END sp_them_nhan_vien2;
/

-- TEST Cau 2
SET SERVEROUTPUT ON;

-- Truong hop 1: Them thanh cong => ket qua = 2
DECLARE
    v_kq NUMBER;
BEGIN
    sp_them_nhan_vien2('NV009', 'NV', 'Chu Thi Lan',
        TO_DATE('15/08/1996','DD/MM/YYYY'), 7000000, 21, 700000, v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq ||
        CASE v_kq WHEN 0 THEN ' - MaNV da ton tai'
                  WHEN 1 THEN ' - MaCV chua ton tai'
                  WHEN 2 THEN ' - Them nhan vien thanh cong' END);
END;
/

-- Truong hop 2: MaNV da ton tai => ket qua = 0
DECLARE
    v_kq NUMBER;
BEGIN
    sp_them_nhan_vien2('NV001', 'NV', 'Nguyen Van An 2',
        TO_DATE('15/03/1975','DD/MM/YYYY'), 20000000, 26, 5000000, v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq ||
        CASE v_kq WHEN 0 THEN ' - MaNV da ton tai'
                  WHEN 1 THEN ' - MaCV chua ton tai'
                  WHEN 2 THEN ' - Them nhan vien thanh cong' END);
END;
/

-- Truong hop 3: MaCV khong ton tai => ket qua = 1
DECLARE
    v_kq NUMBER;
BEGIN
    sp_them_nhan_vien2('NV010', 'QLTC', 'Tran Van Minh',
        TO_DATE('10/04/1994','DD/MM/YYYY'), 8500000, 22, 900000, v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq ||
        CASE v_kq WHEN 0 THEN ' - MaNV da ton tai'
                  WHEN 1 THEN ' - MaCV chua ton tai'
                  WHEN 2 THEN ' - Them nhan vien thanh cong' END);
END;
/


-- ============================================================
-- PHIEU BAI TAP 3 - CAU 3
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_capnhat_ngaysinh (
    p_manv     IN  tblNhanVien.MaNV%TYPE,
    p_ngaysinh IN  tblNhanVien.NgaySinh%TYPE,
    p_ketqua   OUT NUMBER
) AS
    v_dem NUMBER := 0;
BEGIN
    -- Kiem tra nhan vien co ton tai khong
    SELECT COUNT(*) INTO v_dem
    FROM tblNhanVien
    WHERE MaNV = p_manv;

    IF v_dem = 0 THEN
        p_ketqua := 0; -- Khong tim thay
    ELSE
        UPDATE tblNhanVien
        SET NgaySinh = p_ngaysinh
        WHERE MaNV = p_manv;
        COMMIT;
        p_ketqua := 1; -- Cap nhat thanh cong
    END IF;
END sp_capnhat_ngaysinh;
/

-- TEST Cau 3
SET SERVEROUTPUT ON;

-- Truong hop 1: Tim thay nhan vien => cap nhat thanh cong, ket qua = 1
DECLARE
    v_kq NUMBER;
BEGIN
    sp_capnhat_ngaysinh('NV002', TO_DATE('20/07/1986','DD/MM/YYYY'), v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq ||
        CASE v_kq WHEN 0 THEN ' - Khong tim thay nhan vien'
                  WHEN 1 THEN ' - Cap nhat NgaySinh thanh cong' END);
END;
/

-- Truong hop 2: Khong tim thay nhan vien => ket qua = 0
DECLARE
    v_kq NUMBER;
BEGIN
    sp_capnhat_ngaysinh('NV999', TO_DATE('01/01/2000','DD/MM/YYYY'), v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq ||
        CASE v_kq WHEN 0 THEN ' - Khong tim thay nhan vien'
                  WHEN 1 THEN ' - Cap nhat NgaySinh thanh cong' END);
END;
/
