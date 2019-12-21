-- file : speed_judgment.vhd
-- fuction : ������������һ������֮���ʱ����clk��(wheel_interval)����ߵ��ٳ���������ֵ��ʱ�Ӽ��(interval_threshold)�Ƚϡ�
-- 		   	 ��wheel_interval<interval_threshold��Ϊ����ʹ�ܡ���wheel_interval>interval_threshold��Ϊ����ʹ�ܡ�
-- author : ojw
-- createDate : 2019-12-15

-- ʹ�ò���
-- clk_wheelƵ�� f  1s���м���clk����
-- �ߵ�����ֵ v km/h = 0.28*v m/s
-- ����תһȦ�� PI*d cm
-- תһȦ����clk������ (PI*d/10^2) / (0.28*v) * f

-- �����涨
-- clk_wheel: f = 50 Hz
-- ����������ܳ�1.88684�ף���̥175/70R14�����߸��ٵļ���140km/h����1s��ת20.7Ȧ��
-- ��������С�ܳ�1.81458�ף���̥185/60R14�����߸��ٵļ���140km/h����1s��ת21.6Ȧ��
-- �����������ת25Ȧ����ôʱ��Ҫ1s����50�����ܲ��١�

-- �����涨
-- interval_threshold := 34
-- ���ݣ�����10����km/h
-- ����������ܳ�1.88684�ף���̥175/70R14�����߸ߵ���ֵ10km/h����1s��ת1.48Ȧ��
-- ��������С�ܳ�1.81458�ף���̥185/60R14�����߸ߵ���ֵ10km/h����1s��ת1.54Ȧ��
-- ������175/70R14����1s��ת1.48Ȧ��1s�ļ��ʱ����50/1.48=33.78������34

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity speed_judgment is
	generic(interval_threshold : integer := 34);	-- �ߵ��ٳ���������ֵ��ʱ�Ӽ��clk�����жϽ��ޣ����������
	port (
		clk_50Hz 	   : in std_logic;	-- ��Ƶ��ñ�ģ��ר�õ�ʱ��clk
		wheel 		   : in std_logic;	-- �������壬ÿת1Ȧ���1�������壬'1'��Ч
		speed_high	   : out std_logic;	-- �������ʹ��
		speed_low 	   : out std_logic;	-- �������ʹ��
		wheel_interval : out std_logic_vector(7 downto 0);	-- ��ǰ�������ڵ�clk������������
		wait_clk	   : out std_logic_vector(7 downto 0);	-- �ۼƵ���clk��
		wait_pulse 	   : out std_logic	-- ���ټ�ʱ����		 
		  );
end speed_judgment;

architecture bhv of speed_judgment is
begin
	process(wheel,clk_50Hz)
		variable wheel_interval_out : std_logic_vector(7 downto 0);	-- ���������clk������������	
		variable wait_clk_out : std_logic_vector(7 downto 0);	-- �ۼ�ȫ�̵���clk������������
	begin	
		if wheel='1' then
			wheel_interval_out := (others => '0');	-- ���µĳ������������ص������Լ��clk�����㣬�����ۼ��µļ��
			wait_clk_out := (others => '0');
		elsif rising_edge(clk_50Hz) then
			wheel_interval_out := wheel_interval_out + 1;	-- �ۼ���������clk��
			wait_clk_out := wait_clk_out + 1;		
			if conv_integer(wait_clk_out)>25 then	-- Ϊ������棬�˴������wait_clk_out��Ϊ25���൱��wait_unit=0.5s��������
				wait_pulse <= '1';	-- ������״̬��clk���ﵽ25�����ټ�ʱ�������
				wait_clk_out := (others => '0');	-- ��wait_clk_out���㣬׼����һ�εĵ���clk�ۼ�						
			else
				wait_pulse <= '0';	
			end if;						
			if (conv_integer(wheel_interval_out)<interval_threshold) then	-- �ж�Ϊ����
				speed_high <= '1';
				speed_low <= '0';
			else	-- �ж�Ϊ����
				speed_high <= '0';
				speed_low <= '1';
			end if;	
		end if;
		wait_clk <= wait_clk_out;
		wheel_interval <= wheel_interval_out;		
	end process;
end bhv;
		
		
		
		
		  