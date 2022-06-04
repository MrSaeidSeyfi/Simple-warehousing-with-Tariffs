DECLARE 
    @idProduct int,
	@result int,
	@return_value int;   

DECLARE cursor_product CURSOR

FOR SELECT 
        tblProduct.Product_Id
    FROM 
        tblProduct;
OPEN cursor_product;
FETCH NEXT FROM cursor_product INTO 
    @idProduct;

WHILE @@FETCH_STATUS = 0
    BEGIN
       
EXEC	@return_value = [dbo].[Sp_CostContainer] @idProduct

insert into tblCosts values (@return_value,@idProduct)
        FETCH NEXT FROM cursor_product INTO 
           @idProduct;
    END;
CLOSE cursor_product;

DEALLOCATE cursor_product;