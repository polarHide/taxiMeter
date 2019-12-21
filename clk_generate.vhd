-- file : clk_generate.vhd
-- fuction : �ӻ�Ƶ1MHz������Ƶʱ�ӣ�
-- 			clk_50Hz��50Hzʱ��������ʾģ����ߵ����ж�ģ��
-- 			clk_20kHz��20KHz(50us)���ڼƼ�ģ��
-- author : ojw
-- createDate : 2019-12-19

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_generate is
	port(
		clk_1MHz : in std_logic;	-- ��Ƶ
		rst 	  : in std_logic;
		clk_50Hz  : out std_logic;	-- ��Ƶ50Hz
		clk_20KHz : out std_logic	-- ��Ƶ20KHz
		);
end clk_generate;

architecture bhv of clk_generate is
	signal prescaler_50Hz : unsigned(23 downto 0);	-- Ԥ��Ƶ����50Hz
	signal prescaler_20KHz : unsigned(23 downto 0);		-- Ԥ��Ƶ����20KHz
	signal clk_50Hz_out : std_logic;
	signal clk_20KHz_out : std_logic;
begin
	-- 50Hz��Ƶ����
	clk_50Hz_generate : process(clk_1MHz, rst)
	begin
		if rst = '1' then	-- rst=0ʱ��Ƶ��rst=1ʱ��λ
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

	-- 20KHz��Ƶ����	
	clk_20KHz_generate : process(clk_1MHz, rst)
	begin
		if rst = '1' then	-- rst=0ʱ��Ƶ��rst=1ʱ��λ
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