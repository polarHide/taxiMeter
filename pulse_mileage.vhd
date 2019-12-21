-- file : pulse_mileage.vhd
-- fuction : �ۼƳ�������������ÿ�ﵽ1��100mʱ�����һ���������
-- author : ojw
-- createDate : 2019-12-15

-- ����˵��
-- ����������run_unit��Ϊ100m
-- ����������ܳ�1.88684�ף���̥175/70R14������100mת52.998Ȧ������53Ȧ��������interval_wheel��Ϊ53

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity pulse_mileage is
--	generic(run_unit : integer := 100);
--	generic(wheel_circumference : integer := 2);	
	generic(interval_wheel : integer := 53);	-- run_unit/wheel_circumferenceȡ��
	port(
		wheel 		: in std_logic;
		wheel_count : out std_logic_vector(7 downto 0);	-- �ۼƳ���������
		run_pulse   : out std_logic;	-- �������
		run_pulse_count : out std_logic_vector(7 downto 0)	-- ���������		
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
				wheel_count_out := (others => '0');	-- �����������壬����wheel_count_out�������ۼ�
				else run_pulse <='0';
			end if;
			wheel_count <= wheel_count_out;
		end if;	
	end process;
end bhv;