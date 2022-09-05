-- 1. 1-100 diapazonunda olan cüt rəqəmləri ekrana çıxarın
DECLARE @a int = 1
WHILE @a <= 100
BEGIN
	IF @a % 2 = 0
		PRINT @a
	SET @a += 1
END

-- 2. Authorların sayını Authors adlı dəyişəndə saxlayın, daha sonra bu dəyişəni 5ə vuraraq ekrana çıxarın
USE Library
GO
DECLARE @Authors int = 0
SET @Authors = (SELECT COUNT(*) FROM Authors)
PRINT @Authors * 5

-- 3. 5 rəqəmli ədədin polindrom olub olmadığını tapın.
DECLARE @number int = 11111
DECLARE @number1 int = @number
DECLARE @temp int = 0
DECLARE @rem int = 0
WHILE @number1 > 0
BEGIN
	SET @rem = @number1 % 10
	SET @temp = (@temp * 10) + @rem
	SET @number1 = @number1 / 10
END
IF @number = @temp
	PRINT CAST(@number AS nvarchar) + ' is polindrom'
ELSE
	PRINT CAST(@number AS nvarchar) + ' is not polindrom'

-- 4. İstifadəçinin daxil etdiyi aralıqda (məs 10 və 30) cüt rəqəmlərin cəmini tək rəqəmlərin hasilini hesablayan proqram yazın.

DECLARE @sNum int = 10
DECLARE @bNum int = 30
DECLARE @num int = 0
DECLARE @odd int = 1
DECLARE @even int = 0

WHILE @sNum <= @bNum
BEGIN
	IF @sNum % 2 = 0
		BEGIN
		SET @even += @sNum
		END
	ELSE
		BEGIN
		SET @odd *= @sNum
		END
	SET @sNum = @sNum + 1
END

PRINT 'ODD: '
PRINT @odd
PRINT 'EVEN: '
PRINT @even


-- 5. Ədədin faktorialını tapan proqram yazın
DECLARE @a int = 3
DECLARE @fak int = 1
WHILE @a > 0
BEGIN
	SET @fak *= @a
	SET @a -= 1
END
PRINT @fak

-- 6. İstifadəçi tam ədəd daxil edir, bu ədədin qalıqsız bölündüyü bütün rəqəmləri ekrana çıxaran proqram yazın.

DECLARE @input int = 34
DECLARE @i int = 1
WHILE @i <= @input / 2
BEGIN
	IF @input % @i = 0
		PRINT @i
	SET @i += 1
END
PRINT @input


-- 7. Ədədin üstünü hesablayan proqram yazın
DECLARE @n int = 3
DECLARE @p int = 5
DECLARE @n1 int = 1
WHILE @p > 0
BEGIN
	SET @n1 *= @n
	SET @p -= 1
END
PRINT @n1

