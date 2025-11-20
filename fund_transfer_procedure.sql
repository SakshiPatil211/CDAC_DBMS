drop procedure if exists transfer_funds;
delimiter $$
create procedure transfer_funds(IN p_from_acc INT, IN p_to_acc INT, IN p_amount INT)
begin
declare v_from_balance INT;
if p_amount <=0 then
signal sqlstate '45000' set message_text = 'Transfer amount must be positive';
end if;

start transaction;

select balance into v_from_balance
from accounts
where acc_no = p_from_acc for update;

if v_from_balance is null then
rollback;
SIGNAL SQLSTATE '45000' SET message_text = 'Source account not found.';
elseif v_from_balance < p_amount then
rollback;
SIGNAL SQLSTATE '45000' SET message_text = 'Insufficient balance.';
else
update accounts
set balance = balance - p_amount
where acc_no = p_from_acc;

update accounts
set balance = balance + p_amount
where acc_no = p_to_acc;

if row_count() = 0 then
ROLLBACK;
SIGNAL SQLSTATE '45000' SET message_text = 'Destination account not found.';
else
insert into transaction_history (from_acc,to_acc,amount) values(p_from_acc,p_to_acc,p_amount);
commit;
end if;
end if;
end$$
delimiter ;
