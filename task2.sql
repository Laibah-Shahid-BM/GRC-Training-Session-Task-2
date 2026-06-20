create database abc_store;
use abc_store;

create table categories (
    category_id        INT PRIMARY KEY AUTO_INCREMENT,
    category_name      VARCHAR(60) NOT NULL,
    parent_category_id INT NULL,
    FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)
);

create table customers(
	customer_id int auto_increment primary key,
    customer_name varchar(100) not null,
    registration_date date not null
    );
    
create table products(
	product_id int auto_increment primary key,
    product_name varchar(200) not null,
    category_id    INT not null,
    unit_price     int not null,
    stock_quantity INT not null,
    foreign key (category_id) references categories(category_id)
);

create table orders(
	 order_id int auto_increment primary key,
    customer_id int not null,
    order_date  DATE not null,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

create table order_items (
    order_item_id int auto_increment primary key,
    order_id       int not null,
    product_id    int not null,
    quantity      int not null,
    unit_price     int not null,
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

create table payments (
    payment_id  int auto_increment primary key,
    order_id      int not null,
    payment_date DATE NOT NULL,
    amount        int not null,
    status       VARCHAR(20) NOT NULL,     
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO categories (category_name, parent_category_id) VALUES
('Electronics', NULL),   -- 1
('Mobiles',     1),      -- 2
('Smartphones', 2),      -- 3
('Computers',   1),      -- 4
('Laptops',     4),      -- 5
('Books',       NULL),   -- 6
('Furniture',   NULL);   -- 7

-- customer 6 (James) never orders -> tests LEFT JOIN in Task 1
INSERT INTO customers (customer_name, registration_date) VALUES
('Ayesha Khan',   '2025-06-01'),  -- 1
('Daniel Smith',  '2025-06-15'),  -- 2
('Mei Lin',       '2025-07-10'),  -- 3
('Omar Farooq',   '2025-08-05'),  -- 4
('Sophie Martin', '2025-09-01'),  -- 5
('James Brown',   '2025-10-20'),  -- 6  (no orders)
('Fatima Ali',    '2026-01-15');  -- 7

-- products 2,4,8,10 are under stock 10 -> Task 17 restock cursor
INSERT INTO products (product_name, category_id, unit_price, stock_quantity) VALUES
('iPhone 15',           3, 999,  25),  -- 1
('Samsung Galaxy S24',  3, 899,   8),  -- 2
('Pixel 8',             3, 699,  15),  -- 3
('Dell XPS 13',         5, 1199,  5),  -- 4
('MacBook Air',         5, 1099, 12),  -- 5
('Lenovo ThinkPad',     5, 999,  20),  -- 6
('Clean Code',          6, 32,  100),  -- 7
('Pragmatic Programmer',6, 38,    7),  -- 8
('Office Chair',        7, 189,  30),  -- 9
('Standing Desk',       7, 349,   4);  -- 10

-- orders spread across the last ~12 months -> Task 7 monthly revenue.
-- Ayesha (cust 1) has 4 orders incl. one unpaid -> Task 2.
INSERT INTO orders (customer_id, order_date) VALUES
(1, '2025-06-05'),  -- 1  Ayesha (4 days after reg -> Task 8)
(1, '2025-07-12'),  -- 2  Ayesha
(1, '2025-09-20'),  -- 3  Ayesha
(1, '2026-02-10'),  -- 4  Ayesha  (UNPAID)
(2, '2025-06-20'),  -- 5  Daniel  (5 days after reg -> Task 8)
(2, '2025-08-15'),  -- 6  Daniel
(3, '2025-08-01'),  -- 7  Mei     (22 days after reg -> NOT within 7)
(4, '2025-08-10'),  -- 8  Omar    (5 days after reg -> Task 8)
(5, '2025-11-05'),  -- 9  Sophie
(7, '2026-01-18'),  -- 10 Fatima  (3 days after reg -> Task 8)
(3, '2025-12-01'),  -- 11 Mei     (Pending payment)
(5, '2026-03-15'),  -- 12 Sophie
(2, '2026-05-10');  -- 13 Daniel

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 999), (1, 7, 2, 32),     -- O1  = 1063.00
(2, 5, 1, 1099),                       -- O2  = 1099.00
(3, 9, 1, 189), (3, 10, 1, 349),    -- O3  =  538.99
(4, 3, 1, 699),                        -- O4  =  699.00 (unpaid)
(5, 2, 1, 899),                        -- O5  =  899.00
(6, 8, 3, 38),                         -- O6  =  115.50
(7, 4, 1, 1199),                       -- O7  = 1199.00
(8, 1, 2, 999),                        -- O8  = 1998.00
(9, 6, 1, 999), (9, 7, 1, 32),      -- O9  = 1031.00
(10, 10, 1, 349),                      -- O10 =  349.99
(11, 5, 1, 1099),                      -- O11 = 1099.00 (pending)
(12, 2, 1, 899), (12, 9, 1, 189),   -- O12 = 1088.00
(13, 3, 2, 699);                       -- O13 = 1398.00

-- O4 has NO payment (unpaid). O11 is Pending. Rest Completed.
INSERT INTO payments (order_id, payment_date, amount, status) VALUES
(1,  '2025-06-06', 1063, 'Completed'),
(2,  '2025-07-14', 1099, 'Completed'),
(3,  '2025-09-23',  538, 'Completed'),
(5,  '2025-06-20',  899, 'Completed'),
(6,  '2025-08-17',  115, 'Completed'),
(7,  '2025-08-04', 1199, 'Completed'),
(8,  '2025-08-12', 1998, 'Completed'),
(9,  '2025-11-06', 1031, 'Completed'),
(10, '2026-01-20',  349, 'Completed'),
(11, '2025-12-01', 1099, 'Unpaid'),
(12, '2026-03-16', 1088, 'Completed'),
(13, '2026-05-12', 1398, 'Completed');

-- Task 1
select c.customer_name, count(o.order_id) as total_orders, sum(p.amount) as total_pay 
from customers c
left join orders o on c.customer_id = o.customer_id
left join payments p on o.order_id = p.order_id
group by c.customer_name;

-- Task 2 
Select c.customer_name, count(o.order_id) as total_orders, sum(case WHEN p.status = 'Unpaid' OR p.payment_id IS NULL then 1 else 0 end) as total_unpaid
from customers c
inner join orders o on c.customer_id = o.customer_id
left join payments p on o.order_id = p.order_id 
where c.customer_id in(
 SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 3
)
group by c.customer_id, c.customer_name;

-- Task 3
Select p.product_name, count(distinct o.customer_id) as total_customer, 
sum(oi.quantity) as total_unit_sold, sum(oi.quantity * oi.unit_price) as revenue
from products p
inner join order_items oi on p.product_id = oi.product_id
inner join orders o on oi.order_id = o.order_id
inner join customers c on c.customer_id = o. customer_id
group by p.product_id, p.product_name
order by  revenue desc;

-- Task 4
Select o.order_id, c.customer_name,o.order_date, p.payment_date, p.status,
case when p.status = 'Completed' then datediff(p.payment_date, o.order_date ) else NULL end as days_to_payment
from orders o 
inner join customers c on c.customer_id = o.customer_id 
left join payments p on o.order_id = p.order_id
order by o.order_id asc;

-- task 5
with productsales as(
	select c.category_name, p.product_name, sum(oi.quantity) as total_sold,
    row_number() over(
    partition by c.category_id
    order by sum(oi.quantity) desc
    ) as rn
    from categories c 
    inner join products p on c.category_id = p.category_id
    inner join order_items oi on oi.product_id = p.product_id
    group by c.category_id, c.category_name, p.product_id, p.product_name
    )
    select category_name, product_name, total_sold from productsales
    WHERE rn <= 3
	ORDER BY category_name, rn;
    
    -- task 6
    with customer_spending as (
    select c.customer_id, c.customer_name, sum(p.amount) as total_spending from customers c
    inner join orders o on c.customer_id = o.customer_id
    inner join payments p on o.order_id = p.order_id
    where p.status = 'completed'
    group by c.customer_id, c.customer_name
)
select customer_name, total_spending,
    case when total_spending > (
            select avg(total_spending)
            from customer_spending
        ) then 'above average'
        when total_spending = (
            select avg(total_spending)
            from customer_spending
        ) then 'average'
        else 'below average'
    end as spending_status
from customer_spending;

-- task 7
with monthly_revenue as (
    select date_format(payment_date, '%y-%m') as month, sum(amount) as revenue
    from payments
    where status = 'completed'
    group by date_format(payment_date, '%y-%m')
)
select month, revenue, sum(revenue) over ( order by month) as cumulative_revenue
from monthly_revenue
order by month;

-- task 8
with first_orders as (
    select c.customer_id, c.customer_name, c.registration_date, min(o.order_date) as first_order_date
    from customers c
    inner join orders o on c.customer_id = o.customer_id
    group by c.customer_id, c.customer_name, c.registration_date
)
select customer_name, registration_date, first_order_date,
datediff(first_order_date, registration_date) as gap_days
from first_orders
where datediff(first_order_date, registration_date) <= 7;

-- task 9
with recursive category_hierarchy as (
    select category_id, category_name, parent_category_id,
    category_name as full_path
    from categories
    where parent_category_id is null

    union all

    select c.category_id, c.category_name, c.parent_category_id,
    concat(ch.full_path, ' > ', c.category_name)
    from categories c
    inner join category_hierarchy ch on c.parent_category_id = ch.category_id
)
select category_id, full_path
from category_hierarchy
order by full_path;

-- task 10
create view vw_customer_order_summary as
select c.customer_name,
count(o.order_id) as total_orders,
coalesce(sum(p.amount),0) as total_spent,
max(o.order_date) as recent_order
from customers c
left join orders o on c.customer_id = o.customer_id
left join payments p on o.order_id = p.order_id and p.status = 'completed'
group by c.customer_id, c.customer_name;

-- testing query
select *
from vw_customer_order_summary
order by total_spent desc
limit 10;

-- task 11
create index idx_order_items_product
on order_items(product_id);

select p.product_name,
count(distinct o.customer_id) as distinct_customers,
sum(oi.quantity) as total_units_sold,
sum(oi.quantity * oi.unit_price) as total_revenue
from products p
inner join order_items oi on p.product_id = oi.product_id
inner join orders o on oi.order_id = o.order_id
group by p.product_id, p.product_name
order by total_revenue desc;

-- task 12
delimiter $$
create function fn_customer_lifetime_value(p_customer_id int)
returns decimal(10,2)

deterministic

begin

    -- variable to store total spending
    declare total_spent decimal(10,2);

    -- calculate total completed payments of the customer
    select ifnull(sum(p.amount),0)
    into total_spent
    from orders o
    inner join payments p on o.order_id = p.order_id
    where o.customer_id = p_customer_id
    and p.status = 'completed';

    -- return the calculated value
    return total_spent;

end $$

delimiter ;

select fn_customer_lifetime_value(1) as lifetime_value;

-- task 13
delimiter $$

create function fn_order_discount(p_order_id int)
returns decimal(10,2)

deterministic

begin

    -- variable for total order amount
    declare order_total decimal(10,2);

    -- variable for final discounted amount
    declare discounted_total decimal(10,2);

    -- calculate total value of the order
    select sum(quantity * unit_price)
    into order_total
    from order_items
    where order_id = p_order_id;

    -- if order does not exist
    if order_total is null then
        return 0;
    end if;

    -- apply discount rules
    if order_total > 10000 then

        set discounted_total = order_total * 0.90;

    elseif order_total > 5000 then

        set discounted_total = order_total * 0.95;

    else

        set discounted_total = order_total;

    end if;

    -- return discounted amount
    return discounted_total;

end $$

delimiter ;

select fn_order_discount(1) as discounted_total;

-- task 14
delimiter $$

create procedure sp_orders_by_date_range(
    in p_start_date date,
    in p_end_date date
)

begin

    -- return all orders between the given dates
    select o.order_id, c.customer_name,
    sum(oi.quantity) as total_items,
    sum(oi.quantity * oi.unit_price) as order_total
    from orders o
    inner join customers c on o.customer_id = c.customer_id
    inner join order_items oi on o.order_id = oi.order_id
    where o.order_date between p_start_date and p_end_date
    group by o.order_id, c.customer_name
    order by o.order_date;

end $$

delimiter ;

call sp_orders_by_date_range('2025-06-01','2025-12-31');

-- task 15
alter table payments
modify status varchar(20);

drop procedure if exists sp_place_order;

delimiter $$

create procedure sp_place_order(

    in p_customer_id int,
    in p_product_id int,
    in p_quantity int

)

begin

    -- variables
    declare v_order_id int;
    declare v_price decimal(10,2);

    -- rollback if any error occurs
    declare exit handler for sqlexception

    begin

        rollback;

        select 'transaction rolled back because an error occurred.' as message;

    end;

    -- begin transaction
    start transaction;

    -- create new order
    insert into orders(customer_id, order_date)
    values(p_customer_id, curdate());

    -- save generated order id
    set v_order_id = last_insert_id();

    -- get product price
    select unit_price
    into v_price
    from products
    where product_id = p_product_id;

    -- insert order item
    insert into order_items(order_id, product_id, quantity, unit_price)
    values(v_order_id, p_product_id, p_quantity, v_price);

    -- deduct stock
    update products
    set stock_quantity = stock_quantity - p_quantity
    where product_id = p_product_id;

    -- create pending payment
    insert into payments(order_id, payment_date, amount, status)

    values(

        v_order_id,
        curdate(),
        v_price * p_quantity,
        'pending'

    );

    -- save everything
    commit;

    select 'order placed successfully.' as message;

end $$

delimiter ;

call sp_place_order(1,2,3);

select *
from orders
order by order_id desc;

select *
from order_items
order by order_item_id desc;

select *
from payments
order by payment_id desc;

select *
from products;

-- task 16
delimiter $$

create procedure sp_monthly_sales_report(

    in p_year int,
    in p_month int,

    out total_orders int,
    out total_revenue decimal(10,2)

)

begin

    -- calculate total orders
    select count(*)
    into total_orders
    from orders
    where year(order_date) = p_year
    and month(order_date) = p_month;

    -- calculate total completed revenue
    select ifnull(sum(amount),0)
    into total_revenue
    from payments
    where year(payment_date) = p_year
    and month(payment_date) = p_month
    and status = 'completed';

    -- top 5 products
    select p.product_name, sum(oi.quantity) as units_sold
    from products p
    inner join order_items oi on p.product_id = oi.product_id
    inner join orders o on oi.order_id = o.order_id
    where year(o.order_date) = p_year
    and month(o.order_date) = p_month
    group by p.product_id, p.product_name
    order by units_sold desc
    limit 5;

    -- top 3 customers
    select c.customer_name, sum(pay.amount) as total_spent
    from customers c
    inner join orders o on c.customer_id = o.customer_id
    inner join payments pay on o.order_id = pay.order_id
    where year(o.order_date) = p_year
    and month(o.order_date) = p_month
    and pay.status = 'completed'
    group by c.customer_id, c.customer_name
    order by total_spent desc
    limit 3;

end $$

delimiter ;

call sp_monthly_sales_report(2025,8,@orders,@revenue);

select @orders as total_orders,
@revenue as total_revenue;

-- task 17
create table restockalerts(
    alert_id int auto_increment primary key,
    product_name varchar(200),
    current_stock int,
    alert_time datetime
);

delimiter $$
create procedure sp_generate_restock_alerts()
begin
    -- variables
    declare done int default false;
    declare p_name varchar(200);
    declare p_stock int;
    -- cursor query
    declare product_cursor cursor for
    select product_name, stock_quantity
    from products
    where stock_quantity < 10;
    -- stop cursor when rows finish
    declare continue handler for not found
    set done = true;
    open product_cursor;
    
    read_loop: loop
        fetch product_cursor
        into p_name, p_stock;

        if done then
            leave read_loop;

        end if;
        -- insert alert
        insert into restockalerts(
            product_name,
            current_stock,
            alert_time
        )
        values(
            p_name, p_stock, now()
        );
    end loop;
    close product_cursor;
end $$
delimiter ;

call sp_generate_restock_alerts();
select *
from restockalerts;

-- task 18
create table monthlysalesaudit(
    audit_id int auto_increment primary key,
    sales_year int,
    sales_month int,
    total_orders int,
    total_revenue decimal(10,2)
);

delimiter $$
create procedure sp_yearly_audit()
begin
    declare i int default 1;
    declare orders_count int;
    declare revenue decimal(10,2);
    while i <= 12 do
        -- call previous procedure
        call sp_monthly_sales_report(
            2025,
            i,
            orders_count,
            revenue
        );

        -- save results
        insert into monthlysalesaudit(
            sales_year,
            sales_month,
            total_orders,
            total_revenue
        )
        values(
            2025,
            i,
            orders_count,
            revenue
        );

        set i = i + 1;
    end while;
end $$

delimiter ;

call sp_yearly_audit();
select *
from monthlysalesaudit;

select *
from monthlysalesaudit
order by total_revenue desc
limit 1;



    






