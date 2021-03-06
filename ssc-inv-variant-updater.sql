DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updatequantityinstock`()
begin 
	 DECLARE varid integer; 
	 DECLARE qtyInstock integer;
	 DECLARE done integer; 
	 DECLARE cur1 cursor for

	SELECT v.variantid, FLOOR(SUM(inv.weight) / v.package_weight) 
	FROM xcart_variants v 
	INNER JOIN cflsys_warehouse_inventory inv 
	ON inv.productid = v.productid 
	GROUP BY v.variantid; 

	DECLARE Continue Handler for not found 
	Set done = True; open cur1; 
	SET DONE = 0; read_loop: LOOP Fetch cur1 into varId, qtyInstock; if done 
	then leave read_loop; 
	end if; 
	UPDATE xcart_variants as var
	 SET avail = qtyInstock 
	 WHERE var.variantid = varid; 
	 end loop; close cur1; 
	 end$$
DELIMITER ;


-------------------------------------------------------------------------------

---Call procedure---

CALL updatequantityinstock()