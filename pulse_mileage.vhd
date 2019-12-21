-- file : pulse_mileage.vhd
-- fuction : 累计车轮脉冲数，当每达到1个100m时，输出一个里程脉冲
-- author : ojw
-- createDate : 2019-12-15

-- 参数说明
-- 里程跳表距离run_unit，为100m
-- 假设用最大周长1.88684米（轮胎175/70R14），走100m转52.998圈，看作53圈，跳表间隔interval_wheel，为53

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity pulse_mileage is
--	generic(run_unit : integer := 100);
--	generic(wheel_circumference : integer := 2);	
	generic(interval_wheel : integer := 53);	-- run_unit/wheel_circumference取整
	port(
		wheel 		: in std_logic;
		wheel_count : out std_logic_vector(7 downto 0);	-- 累计车轮脉冲数
		run_pulse   : out std_logic;	-- 里程脉冲
		run_pulse_count : out std_logic_vector(7 downto 0)	-- 里程脉计数		
		);
end pulse_mileage;

architecture bhv of pulse_mileage is
begin
	process(wheel)
		variable wheel_count_out : std_logic_vector(7 downto 0);
		variable run_pulse_count_out : std_logic_vector(7 downto 0);		
	begin
		if rising_edge(wheel) then
			wheel_count_out := wheel_count_out + 1;			
			if (conv_integer(wheel_count_out)>interval_wheel) then
				run_pulse_count_out := run_pulse_count_out + 1;				
				run_pulse_count <= run_pulse_count_out;					
				run_pulse <= '1';	
				wheel_count_out := (others => '0');	-- 当输出里程脉冲，清零wheel_count_out，重新累计
				else run_pulse <='0';
			end if;
			wheel_count <= wheel_count_out;
		end if;	
	end process;
end bhv;