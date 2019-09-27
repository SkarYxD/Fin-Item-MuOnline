DECLARE
@acid varchar(10),
@name varchar(10),
@inv_data binary(3792),
@ware_data binary(3840),
@type binary(1),
@group binary(1),
@grupo int,
@item int,
@count int

-- Ingrese el grupo y el número del item que desea buscar
set @grupo    = 0;
set @item    = 2;

print '-------------------------';
print 'ENCONTRADO EN INVENTARIO:';
print '-------------------------';

DECLARE LISTA CURSOR LOCAL FOR
SELECT inventory, name, AccountID FROM Character
OPEN LISTA
FETCH NEXT FROM LISTA INTO @inv_data, @name, @acid
WHILE @@FETCH_STATUS = 0
BEGIN

SET @count=0

WHILE @count<237 AND @inv_data IS NOT NULL
BEGIN
SET @type    =SUBSTRING(@inv_data,@count*16+1,2)
SET @group    =SUBSTRING(@inv_data,@count*16+10,2)

IF (@type = (SELECT CONVERT(varbinary(1), @item)) AND @group = (SELECT CONVERT(varbinary(1), (@grupo*16))))
  BEGIN
    print 'Cuenta: ' + @acid + ' Personaje: ' +  @name;
    SET @count=237;
  END

SET @count=@count+1

END

FETCH NEXT FROM LISTA INTO @inv_data, @name, @acid
END
CLOSE LISTA
DEALLOCATE LISTA

print '------------------';
print 'ENCONTRADO EN BAUL:';
print '------------------';

DECLARE LISTA CURSOR LOCAL FOR
SELECT items, AccountID FROM warehouse
OPEN LISTA
FETCH NEXT FROM LISTA INTO @ware_data, @acid
WHILE @@FETCH_STATUS = 0
BEGIN

SET @count=0

WHILE @count<240 AND @ware_data IS NOT NULL
BEGIN
SET @type    =SUBSTRING(@ware_data,@count*16+1,2)
SET @group    =SUBSTRING(@ware_data,@count*16+10,2)

IF (@type = (SELECT CONVERT(varbinary(1), @item)) AND @group = (SELECT CONVERT(varbinary(1), (@grupo*16))))
  BEGIN
    print 'Cuenta: ' + @acid;
    SET @count=240;
  END

SET @count=@count+1

END

FETCH NEXT FROM LISTA INTO @ware_data, @acid
END
CLOSE LISTA
DEALLOCATE LISTA
