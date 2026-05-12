USE master;
GO

IF EXISTS (
		SELECT 1
		FROM SYS.DATABASES
		WHERE name = 'UniversityGraphDB'
		)
BEGIN
	ALTER DATABASE UniversityGraphDB

	SET SINGLE_USER
	WITH

	ROLLBACK IMMEDIATE;

	DROP DATABASE UniversityGraphDB;
END;

CREATE DATABASE UniversityGraphDB;
GO

USE UniversityGraphDB;
GO

-- ============================================
-- 1. СОЗДАНИЕ ТАБЛИЦ УЗЛОВ (4 ТАБЛИЦЫ)
-- ============================================
-- Узел 1: Группы
CREATE TABLE Groups (
	GroupID INT IDENTITY(1, 1) PRIMARY KEY
	,GroupNumber NVARCHAR(10) NOT NULL
	,Course INT NOT NULL CHECK (
		Course BETWEEN 1
			AND 6
		)
	,EnrollmentYear INT NOT NULL
	,Specialty NVARCHAR(100)
	) AS NODE;

-- Узел 2: Студенты (ФИО разделено)
CREATE TABLE Students (
	StudentID INT IDENTITY(1, 1) PRIMARY KEY
	,LastName NVARCHAR(50) NOT NULL
	,FirstName NVARCHAR(50) NOT NULL
	,MiddleName NVARCHAR(50) NULL
	,BirthDate DATE
	,IsActive BIT DEFAULT 1
	) AS NODE;

-- Узел 3: Предметы
CREATE TABLE Subjects (
	SubjectID INT IDENTITY(1, 1) PRIMARY KEY
	,SubjectName NVARCHAR(150) NOT NULL
	,Credits INT CHECK (Credits > 0)
	,Department NVARCHAR(100)
	) AS NODE;

-- Узел 4: Преподаватели (ФИО разделено)
CREATE TABLE Teachers (
	TeacherID INT IDENTITY(1, 1) PRIMARY KEY
	,LastName NVARCHAR(50) NOT NULL
	,FirstName NVARCHAR(50) NOT NULL
	,MiddleName NVARCHAR(50) NULL
	,Degree NVARCHAR(50)
	,HireDate DATE
	) AS NODE;

-- ============================================
-- 2. СОЗДАНИЕ ТАБЛИЦ РЁБЕР (3 ТАБЛИЦЫ)
-- ============================================
-- Ребро 1: Студент принадлежит Группе (Student -> Group)
CREATE TABLE BelongsTo (
	BelongID INT IDENTITY(1, 1) PRIMARY KEY
	,JoinDate DATE NOT NULL DEFAULT GETDATE()
	,IsMonitor BIT DEFAULT 0
	) AS EDGE;

ALTER TABLE BelongsTo ADD CONSTRAINT EC_BelongsTo CONNECTION (Students TO Groups);

-- Ребро 2: Группа изучает Предмет (Group -> Subject)
CREATE TABLE GroupSubject (
	GroupSubjectID INT IDENTITY(1, 1) PRIMARY KEY
	,Semester NVARCHAR(20) NOT NULL
	,HoursTotal INT
	,ExamType NVARCHAR(20) CHECK (
		ExamType IN (
			'Exam'
			,'Credit'
			,'Coursework'
			)
		)
	) AS EDGE;

ALTER TABLE GroupSubject ADD CONSTRAINT EC_GroupSubject CONNECTION (Groups TO Subjects);

-- Ребро 3: Преподаватель ведёт Предмет (Teacher -> Subject)
CREATE TABLE Teaches (
	TeachID INT IDENTITY(1, 1) PRIMARY KEY
	,StartDate DATE NOT NULL
	,EndDate DATE
	,HoursPerWeek INT
	,IsMainLecturer BIT DEFAULT 1
	) AS EDGE;

ALTER TABLE Teaches ADD CONSTRAINT EC_Teaches CONNECTION (Teachers TO Subjects);

-- ============================================
-- 3. ЗАПОЛНЕНИЕ ТАБЛИЦ УЗЛОВ (ПО 10 СТРОК)
-- ============================================
-- 3.1 Группы (10 строк)
INSERT INTO Groups (
	GroupNumber
	,Course
	,EnrollmentYear
	,Specialty
	)
VALUES (
	N'1'
	,1
	,2025
	,N'Информационные системы'
	)
	,(
	N'2'
	,1
	,2025
	,N'Информационные системы'
	)
	,(
	N'3'
	,1
	,2025
	,N'Прикладная математика'
	)
	,(
	N'4'
	,2
	,2024
	,N'Информационные системы'
	)
	,(
	N'5'
	,2
	,2024
	,N'Информационные системы'
	)
	,(
	N'6'
	,2
	,2024
	,N'Прикладная математика'
	)
	,(
	N'7'
	,3
	,2023
	,N'Информационные системы'
	)
	,(
	N'8'
	,3
	,2023
	,N'Прикладная математика'
	)
	,(
	N'9'
	,4
	,2022
	,N'Информационные системы'
	)
	,(
	N'10'
	,4
	,2022
	,N'Прикладная математика'
	);

-- 3.2 Студенты (10 строк)
INSERT INTO Students (
	LastName
	,FirstName
	,MiddleName
	,BirthDate
	)
VALUES (
	N'Иванов'
	,N'Иван'
	,N'Иванович'
	,'2006-03-15'
	)
	,(
	N'Петрова'
	,N'Анна'
	,N'Сергеевна'
	,'2007-01-20'
	)
	,(
	N'Сидоров'
	,N'Павел'
	,N'Дмитриевич'
	,'2006-07-08'
	)
	,(
	N'Козлова'
	,N'Мария'
	,N'Александровна'
	,'2007-11-30'
	)
	,(
	N'Новиков'
	,N'Артём'
	,N'Олегович'
	,'2006-05-22'
	)
	,(
	N'Морозова'
	,N'Екатерина'
	,N'Игоревна'
	,'2007-02-14'
	)
	,(
	N'Волков'
	,N'Дмитрий'
	,N'Сергеевич'
	,'2006-09-10'
	)
	,(
	N'Соколова'
	,N'Ольга'
	,N'Викторовна'
	,'2006-12-03'
	)
	,(
	N'Кузнецов'
	,N'Максим'
	,N'Андреевич'
	,'2005-04-18'
	)
	,(
	N'Лебедева'
	,N'Татьяна'
	,N'Николаевна'
	,'2005-08-25'
	);

-- 3.3 Предметы (10 строк)
INSERT INTO Subjects (
	SubjectName
	,Credits
	,Department
	)
VALUES (
	N'Базы данных'
	,5
	,N'Информационные системы'
	)
	,(
	N'Программирование на C#'
	,4
	,N'Информационные системы'
	)
	,(
	N'Web-технологии'
	,3
	,N'Информационные системы'
	)
	,(
	N'Операционные системы'
	,5
	,N'Информационные системы'
	)
	,(
	N'Компьютерные сети'
	,4
	,N'Информационные системы'
	)
	,(
	N'Высшая математика'
	,6
	,N'Высшая математика'
	)
	,(
	N'Дискретная математика'
	,5
	,N'Высшая математика'
	)
	,(
	N'Теория вероятностей'
	,4
	,N'Высшая математика'
	)
	,(
	N'Физика'
	,4
	,N'Естественные науки'
	)
	,(
	N'Английский язык'
	,2
	,N'Иностранные языки'
	);

-- 3.4 Преподаватели (10 строк)
INSERT INTO Teachers (
	LastName
	,FirstName
	,MiddleName
	,Degree
	,HireDate
	)
VALUES (
	N'Смирнова'
	,N'Елена'
	,N'Викторовна'
	,N'Кандидат наук'
	,'2018-09-01'
	)
	,(
	N'Козлов'
	,N'Дмитрий'
	,N'Андреевич'
	,N'Доктор наук'
	,'2015-03-15'
	)
	,(
	N'Васильев'
	,N'Сергей'
	,N'Петрович'
	,N'Кандидат наук'
	,'2020-01-10'
	)
	,(
	N'Никитина'
	,N'Анна'
	,N'Сергеевна'
	,N'Кандидат наук'
	,'2019-08-20'
	)
	,(
	N'Григорьев'
	,N'Павел'
	,N'Дмитриевич'
	,N'Доктор наук'
	,'2014-11-01'
	)
	,(
	N'Белова'
	,N'Марина'
	,N'Александровна'
	,N'Старший преподаватель'
	,'2021-09-01'
	)
	,(
	N'Дмитриев'
	,N'Игорь'
	,N'Владимирович'
	,N'Кандидат наук'
	,'2017-02-15'
	)
	,(
	N'Егорова'
	,N'Ольга'
	,N'Николаевна'
	,N'Доктор наук'
	,'2013-06-20'
	)
	,(
	N'Тарасов'
	,N'Андрей'
	,N'Алексеевич'
	,N'Ассистент'
	,'2022-09-01'
	)
	,(
	N'Фёдорова'
	,N'Наталья'
	,N'Михайловна'
	,N'Кандидат наук'
	,'2016-10-12'
	);

-- ============================================
-- 4. ЗАПОЛНЕНИЕ ТАБЛИЦ РЁБЕР
-- ============================================
-- 4.1 BelongsTo: Студент -> Группа (10 связей)
INSERT INTO BelongsTo (
	$FROM_ID
	,$TO_ID
	,JoinDate
	,IsMonitor
	)
SELECT s.$NODE_ID
	,g.$NODE_ID
	,'2025-09-01'
	,CASE s.LastName
		WHEN N'Иванов'
			THEN 1
		ELSE 0
		END
FROM Students s
	,Groups g
WHERE s.LastName IN (
		N'Иванов'
		,N'Петрова'
		)
	AND g.GroupNumber = N'1';

INSERT INTO BelongsTo (
	$FROM_ID
	,$TO_ID
	,JoinDate
	,IsMonitor
	)
SELECT s.$NODE_ID
	,g.$NODE_ID
	,'2025-09-01'
	,CASE s.LastName
		WHEN N'Сидоров'
			THEN 1
		ELSE 0
		END
FROM Students s
	,Groups g
WHERE s.LastName IN (
		N'Сидоров'
		,N'Козлова'
		)
	AND g.GroupNumber = N'2';

INSERT INTO BelongsTo (
	$FROM_ID
	,$TO_ID
	,JoinDate
	,IsMonitor
	)
SELECT s.$NODE_ID
	,g.$NODE_ID
	,'2025-09-01'
	,CASE s.LastName
		WHEN N'Новиков'
			THEN 1
		ELSE 0
		END
FROM Students s
	,Groups g
WHERE s.LastName IN (
		N'Новиков'
		,N'Морозова'
		)
	AND g.GroupNumber = N'3';

INSERT INTO BelongsTo (
	$FROM_ID
	,$TO_ID
	,JoinDate
	,IsMonitor
	)
SELECT s.$NODE_ID
	,g.$NODE_ID
	,'2024-09-01'
	,CASE s.LastName
		WHEN N'Волков'
			THEN 1
		ELSE 0
		END
FROM Students s
	,Groups g
WHERE s.LastName IN (
		N'Волков'
		,N'Соколова'
		)
	AND g.GroupNumber = N'4';

INSERT INTO BelongsTo (
	$FROM_ID
	,$TO_ID
	,JoinDate
	,IsMonitor
	)
SELECT s.$NODE_ID
	,g.$NODE_ID
	,'2024-09-01'
	,CASE s.LastName
		WHEN N'Кузнецов'
			THEN 1
		ELSE 0
		END
FROM Students s
	,Groups g
WHERE s.LastName IN (
		N'Кузнецов'
		,N'Лебедева'
		)
	AND g.GroupNumber = N'5';

-- 4.2 GroupSubject: Группа -> Предмет (10 связей)
-- Группа 1: Базы данных, C#, Высшая математика, Английский
INSERT INTO GroupSubject (
	$FROM_ID
	,$TO_ID
	,Semester
	,HoursTotal
	,ExamType
	)
SELECT g.$NODE_ID
	,sub.$NODE_ID
	,'2025-Осень'
	,180
	,'Exam'
FROM Groups g
	,Subjects sub
WHERE g.GroupNumber = N'1'
	AND sub.SubjectName = N'Базы данных';

INSERT INTO GroupSubject (
	$FROM_ID
	,$TO_ID
	,Semester
	,HoursTotal
	,ExamType
	)
SELECT g.$NODE_ID
	,sub.$NODE_ID
	,'2025-Осень'
	,144
	,'Exam'
FROM Groups g
	,Subjects sub
WHERE g.GroupNumber = N'1'
	AND sub.SubjectName = N'Программирование на C#';

INSERT INTO GroupSubject (
	$FROM_ID
	,$TO_ID
	,Semester
	,HoursTotal
	,ExamType
	)
SELECT g.$NODE_ID
	,sub.$NODE_ID
	,'2025-Осень'
	,216
	,'Exam'
FROM Groups g
	,Subjects sub
WHERE g.GroupNumber = N'1'
	AND sub.SubjectName = N'Высшая математика';

INSERT INTO GroupSubject (
	$FROM_ID
	,$TO_ID
	,Semester
	,HoursTotal
	,ExamType
	)
SELECT g.$NODE_ID
	,sub.$NODE_ID
	,'2025-Осень'
	,72
	,'Credit'
FROM Groups g
	,Subjects sub
WHERE g.GroupNumber = N'1'
	AND sub.SubjectName = N'Английский язык';

-- Группа 2 (1 курс ИС): такие же предметы как у группы 1
INSERT INTO GroupSubject (
	$FROM_ID
	,$TO_ID
	,Semester
	,HoursTotal
	,ExamType
	)
SELECT g.$NODE_ID
	,sub.$NODE_ID
	,'2025-Осень'
	,CASE sub.SubjectName
		WHEN N'Базы данных'
			THEN 180
		WHEN N'Программирование на C#'
			THEN 144
		WHEN N'Высшая математика'
			THEN 216
		WHEN N'Английский язык'
			THEN 72
		END
	,CASE sub.SubjectName
		WHEN N'Английский язык'
			THEN 'Credit'
		ELSE 'Exam'
		END
FROM Groups g
	,Subjects sub
WHERE g.GroupNumber = N'2'
	AND sub.SubjectName IN (
		N'Базы данных'
		,N'Программирование на C#'
		,N'Высшая математика'
		,N'Английский язык'
		);

-- Группа 5 (2 курс ИС): такие же предметы как у группы 4
INSERT INTO GroupSubject (
	$FROM_ID
	,$TO_ID
	,Semester
	,HoursTotal
	,ExamType
	)
SELECT g.$NODE_ID
	,sub.$NODE_ID
	,'2025-Осень'
	,CASE sub.SubjectName
		WHEN N'Операционные системы'
			THEN 180
		WHEN N'Компьютерные сети'
			THEN 144
		WHEN N'Web-технологии'
			THEN 108
		END
	,CASE sub.SubjectName
		WHEN N'Web-технологии'
			THEN 'Credit'
		ELSE 'Exam'
		END
FROM Groups g
	,Subjects sub
WHERE g.GroupNumber = N'5'
	AND sub.SubjectName IN (
		N'Операционные системы'
		,N'Компьютерные сети'
		,N'Web-технологии'
		);

-- Группа 3: Высшая математика, Дискретная математика, Физика
INSERT INTO GroupSubject (
	$FROM_ID
	,$TO_ID
	,Semester
	,HoursTotal
	,ExamType
	)
SELECT g.$NODE_ID
	,sub.$NODE_ID
	,'2025-Осень'
	,216
	,'Exam'
FROM Groups g
	,Subjects sub
WHERE g.GroupNumber = N'3'
	AND sub.SubjectName = N'Высшая математика';

INSERT INTO GroupSubject (
	$FROM_ID
	,$TO_ID
	,Semester
	,HoursTotal
	,ExamType
	)
SELECT g.$NODE_ID
	,sub.$NODE_ID
	,'2025-Осень'
	,180
	,'Exam'
FROM Groups g
	,Subjects sub
WHERE g.GroupNumber = N'3'
	AND sub.SubjectName = N'Дискретная математика';

INSERT INTO GroupSubject (
	$FROM_ID
	,$TO_ID
	,Semester
	,HoursTotal
	,ExamType
	)
SELECT g.$NODE_ID
	,sub.$NODE_ID
	,'2025-Осень'
	,144
	,'Exam'
FROM Groups g
	,Subjects sub
WHERE g.GroupNumber = N'3'
	AND sub.SubjectName = N'Физика';

-- Группа 4: Операционные системы, Компьютерные сети, Web-технологии
INSERT INTO GroupSubject (
	$FROM_ID
	,$TO_ID
	,Semester
	,HoursTotal
	,ExamType
	)
SELECT g.$NODE_ID
	,sub.$NODE_ID
	,'2025-Осень'
	,180
	,'Exam'
FROM Groups g
	,Subjects sub
WHERE g.GroupNumber = N'4'
	AND sub.SubjectName = N'Операционные системы';

INSERT INTO GroupSubject (
	$FROM_ID
	,$TO_ID
	,Semester
	,HoursTotal
	,ExamType
	)
SELECT g.$NODE_ID
	,sub.$NODE_ID
	,'2025-Осень'
	,144
	,'Exam'
FROM Groups g
	,Subjects sub
WHERE g.GroupNumber = N'4'
	AND sub.SubjectName = N'Компьютерные сети';

INSERT INTO GroupSubject (
	$FROM_ID
	,$TO_ID
	,Semester
	,HoursTotal
	,ExamType
	)
SELECT g.$NODE_ID
	,sub.$NODE_ID
	,'2025-Осень'
	,108
	,'Credit'
FROM Groups g
	,Subjects sub
WHERE g.GroupNumber = N'4'
	AND sub.SubjectName = N'Web-технологии';

-- 4.3 Teaches: Преподаватель -> Предмет (10 связей)
INSERT INTO Teaches (
	$FROM_ID
	,$TO_ID
	,StartDate
	,HoursPerWeek
	,IsMainLecturer
	)
SELECT t.$NODE_ID
	,sub.$NODE_ID
	,'2025-09-01'
	,6
	,1
FROM Teachers t
	,Subjects sub
WHERE t.LastName = N'Смирнова'
	AND sub.SubjectName = N'Базы данных';

INSERT INTO Teaches (
	$FROM_ID
	,$TO_ID
	,StartDate
	,HoursPerWeek
	,IsMainLecturer
	)
SELECT t.$NODE_ID
	,sub.$NODE_ID
	,'2025-09-01'
	,4
	,1
FROM Teachers t
	,Subjects sub
WHERE t.LastName = N'Козлов'
	AND sub.SubjectName = N'Программирование на C#';

INSERT INTO Teaches (
	$FROM_ID
	,$TO_ID
	,StartDate
	,HoursPerWeek
	,IsMainLecturer
	)
SELECT t.$NODE_ID
	,sub.$NODE_ID
	,'2025-09-01'
	,3
	,1
FROM Teachers t
	,Subjects sub
WHERE t.LastName = N'Козлов'
	AND sub.SubjectName = N'Web-технологии';

INSERT INTO Teaches (
	$FROM_ID
	,$TO_ID
	,StartDate
	,HoursPerWeek
	,IsMainLecturer
	)
SELECT t.$NODE_ID
	,sub.$NODE_ID
	,'2025-09-01'
	,6
	,1
FROM Teachers t
	,Subjects sub
WHERE t.LastName = N'Васильев'
	AND sub.SubjectName = N'Высшая математика';

INSERT INTO Teaches (
	$FROM_ID
	,$TO_ID
	,StartDate
	,HoursPerWeek
	,IsMainLecturer
	)
SELECT t.$NODE_ID
	,sub.$NODE_ID
	,'2025-09-01'
	,2
	,1
FROM Teachers t
	,Subjects sub
WHERE t.LastName = N'Никитина'
	AND sub.SubjectName = N'Английский язык';

INSERT INTO Teaches (
	$FROM_ID
	,$TO_ID
	,StartDate
	,HoursPerWeek
	,IsMainLecturer
	)
SELECT t.$NODE_ID
	,sub.$NODE_ID
	,'2025-09-01'
	,5
	,1
FROM Teachers t
	,Subjects sub
WHERE t.LastName = N'Григорьев'
	AND sub.SubjectName = N'Операционные системы';

INSERT INTO Teaches (
	$FROM_ID
	,$TO_ID
	,StartDate
	,HoursPerWeek
	,IsMainLecturer
	)
SELECT t.$NODE_ID
	,sub.$NODE_ID
	,'2025-09-01'
	,4
	,1
FROM Teachers t
	,Subjects sub
WHERE t.LastName = N'Белова'
	AND sub.SubjectName = N'Компьютерные сети';

INSERT INTO Teaches (
	$FROM_ID
	,$TO_ID
	,StartDate
	,HoursPerWeek
	,IsMainLecturer
	)
SELECT t.$NODE_ID
	,sub.$NODE_ID
	,'2025-09-01'
	,5
	,1
FROM Teachers t
	,Subjects sub
WHERE t.LastName = N'Егорова'
	AND sub.SubjectName = N'Дискретная математика';

-- Фёдорова ведёт Теорию вероятностей (основной лектор)
INSERT INTO Teaches (
	$FROM_ID
	,$TO_ID
	,StartDate
	,HoursPerWeek
	,IsMainLecturer
	)
SELECT t.$NODE_ID
	,sub.$NODE_ID
	,'2025-09-01'
	,4
	,1
FROM Teachers t
	,Subjects sub
WHERE t.LastName = N'Фёдорова'
	AND sub.SubjectName = N'Теория вероятностей';

-- Фёдорова ведёт Высшую математику (второй преподаватель)
INSERT INTO Teaches (
	$FROM_ID
	,$TO_ID
	,StartDate
	,HoursPerWeek
	,IsMainLecturer
	)
SELECT t.$NODE_ID
	,sub.$NODE_ID
	,'2025-09-01'
	,4
	,0
FROM Teachers t
	,Subjects sub
WHERE t.LastName = N'Фёдорова'
	AND sub.SubjectName = N'Высшая математика';

-- Тарасов ведёт Компьютерные сети (основной лектор)
INSERT INTO Teaches (
	$FROM_ID
	,$TO_ID
	,StartDate
	,HoursPerWeek
	,IsMainLecturer
	)
SELECT t.$NODE_ID
	,sub.$NODE_ID
	,'2025-09-01'
	,4
	,1
FROM Teachers t
	,Subjects sub
WHERE t.LastName = N'Тарасов'
	AND sub.SubjectName = N'Компьютерные сети';

-- Тарасов ведёт Web-технологии (второй преподаватель)
INSERT INTO Teaches (
	$FROM_ID
	,$TO_ID
	,StartDate
	,HoursPerWeek
	,IsMainLecturer
	)
SELECT t.$NODE_ID
	,sub.$NODE_ID
	,'2025-09-01'
	,2
	,0
FROM Teachers t
	,Subjects sub
WHERE t.LastName = N'Тарасов'
	AND sub.SubjectName = N'Web-технологии';

INSERT INTO Teaches (
	$FROM_ID
	,$TO_ID
	,StartDate
	,HoursPerWeek
	,IsMainLecturer
	)
SELECT t.$NODE_ID
	,sub.$NODE_ID
	,'2025-09-01'
	,4
	,1
FROM Teachers t
	,Subjects sub
WHERE t.LastName = N'Дмитриев'
	AND sub.SubjectName = N'Физика';

INSERT INTO Teaches (
	$FROM_ID
	,$TO_ID
	,StartDate
	,HoursPerWeek
	,IsMainLecturer
	)
SELECT t.$NODE_ID
	,sub.$NODE_ID
	,'2025-09-01'
	,4
	,0
FROM Teachers t
	,Subjects sub
WHERE t.LastName = N'Тарасов'
	AND sub.SubjectName = N'Теория вероятностей';

-- ============================================
-- 5. ЗАПРОСЫ С MATCH (ЦЕПОЧКИ ИЗ 3+ УЗЛОВ)
-- ============================================
-- Запрос 5.1: Найти всех студентов и их преподавателей (кто учит каждого студента)
-- Цепочка: Student -> Group -> Subject <- Teacher
SELECT CONCAT_WS(' ', s.LastName, s.FirstName, s.MiddleName) AS StudentName
	,g.GroupNumber
	,sub.SubjectName
	,CONCAT_WS(' ', t.LastName, t.FirstName, t.MiddleName) AS TeacherName
FROM Students s
	,BelongsTo b
	,Groups g
	,GroupSubject gs
	,Subjects sub
	,Teaches teac
	,Teachers t
WHERE MATCH(s - (b) - > g - (gs) - > sub
		AND t - (teac) - > sub)
ORDER BY StudentName
	,sub.SubjectName;

-- Запрос 5.2: Найти преподавателей-кандидатов наук, которые ведут экзамены у первокурсников
-- Цепочка: Teacher -> Subject <- Group <- Student
SELECT DISTINCT CONCAT (
		t.LastName
		,' '
		,t.FirstName
		) AS TeacherName
	,t.Degree
	,sub.SubjectName
	,g.GroupNumber
	,g.Course
	,gs.ExamType
FROM Teachers t
	,Teaches teac
	,Subjects sub
	,GroupSubject gs
	,Groups g
	,BelongsTo b
	,Students s
WHERE MATCH(t - (teac) - > sub
		AND g - (gs) - > sub
		AND s - (b) - > g)
	AND t.Degree = N'Кандидат наук'
	AND g.Course = 1
	AND gs.ExamType = 'Exam'
ORDER BY TeacherName
	,sub.SubjectName;

-- Запрос 5.3: Найти всех студентов докторов наук
-- Цепочка: Student -> Group -> Subject <- Teacher
SELECT DISTINCT CONCAT_WS(' ', s.LastName, s.FirstName, s.MiddleName) AS StudentName
	,g.GroupNumber
	,sub.SubjectName
	,CONCAT_WS(' ', t.LastName, t.FirstName, t.MiddleName) AS DoctorTeacher
	,t.Degree
FROM Students s
	,BelongsTo b
	,Groups g
	,GroupSubject gs
	,Subjects sub
	,Teaches teac
	,Teachers t
WHERE MATCH(s - (b) - > g - (gs) - > sub
		AND t - (teac) - > sub)
	AND t.Degree = N'Доктор наук'
ORDER BY StudentName
	,sub.SubjectName;

-- Запрос 5.4: Найти предметы, которые изучают студенты 2 курса, и кто их преподаёт
-- Цепочка: Student -> Group -> Subject <- Teacher
SELECT DISTINCT g.Course
	,g.GroupNumber
	,sub.SubjectName
	,CONCAT_WS(' ', t.LastName, t.FirstName, t.MiddleName) AS TeacherName
	,t.Degree
	,gs.ExamType
FROM Students s
	,BelongsTo b
	,Groups g
	,GroupSubject gs
	,Subjects sub
	,Teaches teac
	,Teachers t
WHERE MATCH(s - (b) - > g - (gs) - > sub
		AND t - (teac) - > sub)
	AND g.Course = 2
ORDER BY g.GroupNumber
	,sub.SubjectName;

-- Запрос 5.5: Найти всех студентов, которые изучают предметы кафедры "Высшая математика"
-- Цепочка: Student -> Group -> Subject <- Teacher
SELECT DISTINCT CONCAT_WS(' ', s.LastName, s.FirstName, s.MiddleName) AS StudentName
	,g.GroupNumber
	,g.Course
	,sub.SubjectName
	,sub.Department
FROM Students s
	,BelongsTo b
	,Groups g
	,GroupSubject gs
	,Subjects sub
WHERE MATCH(s - (b) - > g - (gs) - > sub)
	AND sub.Department = N'Высшая математика'
ORDER BY StudentName
	,sub.SubjectName;

-- ============================================
-- 6. ЗАПРОСЫ С SHORTEST_PATH
-- ============================================
-- Запрос 6.1: Путь от студента до преподавателя
-- Шаблон "+" — любое количество шагов
SELECT StudentName
	,TeacherName
	,PathLength
FROM (
	SELECT s.FirstName + ' ' + s.LastName AS StudentName
		,LAST_VALUE(tp.FirstName + ' ' + tp.LastName) WITHIN
	GROUP (GRAPH PATH) AS TeacherName
		,COUNT(tp.$NODE_ID) WITHIN
	GROUP (GRAPH PATH) AS PathLength
	FROM Students s
		,BelongsTo
	FOR PATH AS bp
		,Groups
	FOR PATH AS gp
		,GroupSubject
	FOR PATH AS gsp
		,Subjects
	FOR PATH AS subp
		,Teaches
	FOR PATH AS teacp
		,Teachers
	FOR PATH AS tp
	WHERE MATCH(SHORTEST_PATH(s(- (bp) - > gp - (gsp) - > subp < - (teacp) - tp) +))
		AND s.LastName = N'Иванов'
	) AS Paths
WHERE PathLength > 0;

-- Запрос 6.2: Путь от преподавателя до студента
-- Шаблон "{1,5}" — от 1 до 5 шагов
SELECT TeacherName
	,StudentName
	,PathLength
FROM (
	SELECT t.FirstName + ' ' + t.LastName AS TeacherName
		,LAST_VALUE(sp.FirstName + ' ' + sp.LastName) WITHIN
	GROUP (GRAPH PATH) AS StudentName
		,COUNT(sp.$NODE_ID) WITHIN
	GROUP (GRAPH PATH) AS PathLength
	FROM Teachers t
		,Teaches
	FOR PATH AS teacp
		,Subjects
	FOR PATH AS subp
		,GroupSubject
	FOR PATH AS gsp
		,Groups
	FOR PATH AS gp
		,BelongsTo
	FOR PATH AS bp
		,Students
	FOR PATH AS sp
	WHERE MATCH(SHORTEST_PATH(t(- (teacp) - > subp < - (gsp) - gp < - (bp) - sp) {1, 5 }))
		AND t.LastName = N'Смирнова'
	) AS Paths
WHERE PathLength > 0;