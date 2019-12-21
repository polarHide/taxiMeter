-- file : speed_judgment.vhd
-- fuction : 计算脉冲与下一个脉冲之间的时间间隔clk数(wheel_interval)，与高低速车轮脉冲阈值的时钟间隔(interval_threshold)比较。
-- 		   	 当wheel_interval<interval_threshold，为高速使能。当wheel_interval>interval_threshold，为低速使能。
-- author : ojw
-- createDate : 2019-12-15

-- 使用参数
-- clk_wheel频率 f  1s内有几个clk周期
-- 高低速阈值 v km/h = 0.28*v m/s
-- 车轮转一圈走 PI*d cm
-- 转一圈包含clk周期数 (PI*d/10^2) / (0.28*v) * f

-- 参数规定
-- clk_wheel: f = 50 Hz
-- 假设用最大周长1.88684米（轮胎175/70R14），走高速的极限140km/h，走1s会转20.7圈；
-- 假设用最小周长1.81458米（轮胎185/60R14），走高速的极限140km/h，走1s会转21.6圈。
-- 不妨假设最多转25圈，那么时钟要1s里有50个才能测速。

-- 参数规定
-- interval_threshold := 34
-- 广州：低于10公里km/h
-- 假设用最大周长1.88684米（轮胎175/70R14），走高低阈值10km/h，走1s会转1.48圈；
-- 假设用最小周长1.81458米（轮胎185/60R14），走高低阈值10km/h，走1s会转1.54圈。
-- 假设用175/70R14，走1s会转1.48圈，1s的间隔时间数50/1.48=33.78，看作34

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity speed_judgment is
	generic(interval_threshold : integer := 34);	-- 高低速车轮脉冲阈值的时钟间隔clk数（判断界限），参数需改
	port (
		clk_50Hz 	   : in std_logic;	-- 分频获得本模块专用的时钟clk
		wheel 		   : in std_logic;	-- 车轮脉冲，每转1圈输出1个短脉冲，'1'有效
		speed_high	   : out std_logic;	-- 高速输出使能
		speed_low 	   : out std_logic;	-- 低速输出使能
		wheel_interval : out std_logic_vector(7 downto 0);	-- 当前这个间隔内的clk数（过程量）
		wait_clk	   : out std_logic_vector(7 downto 0);	-- 累计低速clk数
		wait_pulse 	   : out std_logic	-- 低速计时脉冲		 
		  );
end speed_judgment;

architecture bhv of speed_judgment is
begin
	process(wheel,clk_50Hz)
		variable wheel_interval_out : std_logic_vector(7 downto 0);	-- 这个脉冲间的clk数（过程量）	
		variable wait_clk_out : std_logic_vector(7 downto 0);	-- 累计全程低速clk数（过程量）
	begin	
		if wheel='1' then
			wheel_interval_out := (others => '0');	-- 当新的车轮脉冲上升沿到来，对间隔clk数清零，从零累计新的间隔
			wait_clk_out := (others => '0');
		elsif rising_edge(clk_50Hz) then
			wheel_interval_out := wheel_interval_out + 1;	-- 累计这个间隔内clk数
			wait_clk_out := wait_clk_out + 1;		
			if conv_integer(wait_clk_out)>25 then	-- 为方便仿真，此处设低速wait_clk_out数为25（相当于wait_unit=0.5s）即跳表
				wait_pulse <= '1';	-- 当低速状态的clk数达到25，低速计时脉冲产生
				wait_clk_out := (others => '0');	-- 对wait_clk_out清零，准备下一次的低速clk累加						
			else
				wait_pulse <= '0';	
			end if;						
			if (conv_integer(wheel_interval_out)<interval_threshold) then	-- 判断为高速
				speed_high <= '1';
				speed_low <= '0';
			else	-- 判断为低速
				speed_high <= '0';
				speed_low <= '1';
			end if;	
		end if;
		wait_clk <= wait_clk_out;
		wheel_interval <= wheel_interval_out;		
	end process;
end bhv;
		
		
		
		
		  