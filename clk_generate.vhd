-- file : clk_generate.vhd
-- fuction : 从基频1MHz产生分频时钟：
------------ clk_50Hz：50Hz时钟用于显示模块与高低速判断模块
------------ clk_20kHz：20KHz(50us)用于计价模块
-- author : ojw
-- createDate : 2019-12-19

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_generate is
	port(
		clk_1MHz : in std_logic;	-- 基频
		rst 	  : in std_logic;
		clk_50Hz  : out std_logic;	-- 分频50Hz
		clk_20KHz : out std_logic	-- 分频20KHz
		);
end clk_generate;

architecture bhv of clk_generate is
	signal prescaler_50Hz : unsigned(23 downto 0);	-- 预分频设置50Hz
	signal prescaler_20KHz : unsigned(23 downto 0);		-- 预分频设置20KHz
	signal clk_50Hz_out : std_logic;
	signal clk_20KHz_out : std_logic;
begin
	-- 50Hz分频进程
	clk_50Hz_generate : process(clk_1MHz, rst)
	begin
		if rst = '1' then	-- rst=0时分频，rst=1时复位
			clk_50Hz_out <= '0';
			prescaler_50Hz <= (others => '0');
		elsif rising_edge(clk_1MHz) then
			if prescaler_50Hz = X"2710" then
				prescaler_50Hz <= (others => '0');
				clk_50Hz_out <= not clk_50Hz_out;
			else
				prescaler_50Hz <= prescaler_50Hz + "1";
			end if;
		end if;
	end process clk_50Hz_generate;

	-- 20KHz分频进程	
	clk_20KHz_generate : process(clk_1MHz, rst)
	begin
		if rst = '1' then	-- rst=0时分频，rst=1时复位
			clk_20KHz_out <= '0';
			prescaler_20KHz <= (others => '0');
		elsif rising_edge(clk_1MHz) then
			if prescaler_20KHz = X"19" then
				prescaler_20KHz <= (others => '0');
				clk_20KHz_out <= not clk_20KHz_out;
			else
				prescaler_20KHz <= prescaler_20KHz + "1";
			end if;
		end if;
	end process clk_20KHz_generate;	
clk_50Hz <= clk_50Hz_out;
clk_20KHz <= clk_20KHz_out;
end bhv;		
