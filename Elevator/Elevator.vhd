----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:57:57 03/18/2014 
-- Design Name: 
-- Module Name:    Elevator - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity Elevator is
Port ( clk1 : in std_logic;
reset : in std_logic:='0';
f1 : in std_logic:='0';
f2 : in std_logic:='0';
f3 : in std_logic:='0';
f4 : in std_logic:='0';
u1 : in std_logic:= '0';
u2 : in std_logic:='0';
u3 : in std_logic:='0';
u4 : in std_logic:='0';
d1 : in std_logic:='0';
d2 : in std_logic:='0';
d3 : in std_logic:='0';
d4 : in std_logic:='0';
motor :out std_logic;
stop: in std_logic:='1';
up : out std_logic;
down : out std_logic;
requestFloor : out std_logic;
dooropen : out std_logic;
doorclose : out std_logic);
end Elevator;

architecture Behavioral of Elevator is

type state_type is (Idle,SetDirection,Moving,StopState,opennClosed,IncrementDecrementFloorSensor);
signal doorStart,doorFinish:std_logic;
signal current_state,next_state:state_type;
signal current_floor: std_logic_vector(1 downto 0):="00";
signal changeDir:std_logic:='1';
signal top:std_logic_vector(1 downto 0):="00";
signal up_list,down_list: std_logic_vector(3 downto 0 ):="0000";
signal clr:std_logic:='0'; 

signal StopSensor1:std_logic;
signal StopSensor2:std_logic;
signal emptyList:std_logic;

begin

process(clk1, reset)
      
      begin 
        if(reset = '1') then
          current_state <=  Idle;
        elsif (rising_edge(clk1)) then
          current_state <= next_state;
        end if;
		  
      end process;
	
	



	
process(f1,f2,f3,f4,clr,u4,u3,u2,u1,d1,d2,d3,d4)


begin 


 


--UpList


if((f4 = '1' and current_floor = "00") or (f4 = '1' and current_floor = "01") or (f4 = '1' and current_floor = "10") or u4 = '1')then
	
	
	up_list(3) <='1';
	
	

 end if;
 ------------------------------
if((f3 = '1' and current_floor = "00") or (f3 ='1' and current_floor = "01") or u3 = '1')then
		if(changeDir = '0' and u3 = '1' and d3 /='1')then
		down_list(2) <= '1';
	else
		
		up_list(2)<='1';
			
	end if;

end if;
-------------------------------
if((f2 = '1' and current_floor = "00") or u2 = '1') then
	if(changeDir = '0' and u2 = '1' and d2 /= '1')then
		down_list(1)<='1';
	else
	
	up_list(1)<='1';
	
		end if;

end if;
if(u1 = '1')then
down_list(0)<='1';
end if;

--end if;
-------------------------------




--DownList


if((f1 = '1' and current_floor = "11") or (f1 = '1' and current_floor = "10") or (f1 = '1' and current_floor = "01") or d1 ='1' )then
	down_list(0) <='1';

	

 end if;
 ------------------------------
if((f2 = '1' and current_floor = "11") or (f2 = '1' and current_floor = "10") or d2 = '1')then
		
		if(changeDir = '1' and d2 = '1' and u2 /= '1')then
	  up_list(1)<='1';
	  else
		
		down_list(1)<='1';
			
		end if;

end if;
-------------------------------
if((f3 = '1' and current_floor = "11") or d3 = '1') then
	
	if(changeDir = '1' and d3 = '1' and u3 /='1')then
	  up_list(2)<='1';
	  else


	down_list(2)<='1';
	
	end if;

end if;
if(d4 = '1')then
up_list(3)<='1';
end if;

--end if;
-------------------------------


-------------------------------
if(changeDir ='1')then
 if(up_list(3) = '1')then
	top <="11";
	elsif(up_list(2) = '1')then
	 top <="10";
	 elsif(up_list(1) = '1')then
		top <= "01";
		end if;
		end if;
		
if(changeDir = '0')then
	if(down_list(0)= '1')then
		top<="00";
		elsif(down_list(1) ='1')then
		 top<="01";
		 elsif(down_list(2) = '1')then
		 top<="10";
		 end if;
		 end if;
		 

if(clr = '1')then
		if(up_list(conv_Integer(unsigned(current_floor))) = '1' and down_list(conv_Integer(unsigned(current_floor))) = '1')then
		up_list(conv_Integer(unsigned(current_floor))) <= '0';
		down_list(conv_Integer(unsigned(current_floor))) <= '0';
		
		end if;
		
end if;
if(clr = '1')then
	if(changeDir = '1')then
			up_list(conv_Integer(unsigned(current_floor))) <= '0';
			
	else
			down_list(conv_Integer(unsigned(current_floor))) <= '0';
			
	end if;
	

end if;


end process;
		
process(current_state, stop, emptyList,top,clr)
	
	
	begin 
	
	
	
	
	case current_state is 
	-- make sure motor is zero 
	when Idle =>
	motor <= '0';
	emptyList<='0';
	if(emptyList = '1')then
		next_state <= Idle;
		
		changeDir <= not changeDir;
		
	else
		next_state <= SetDirection;
		
		
	end if;
	
	
	--  make sure motor is zero
	when SetDirection =>
		motor <= '0';
		if(up_list > "0000" and changeDir = '1') then--check syntax for 
			up <= '1'; 
			down <= '0';
			StopSensor1 <= '0';
			StopSensor2<= '0';
			clr<='0';
			changeDir <='1';
			next_state <= Moving; -- dir set up, go to move state
		elsif(down_list > "0000" and changeDir = '0') then
			up <= '0';
			down <='1';
			StopSensor1 <= '0';
			StopSensor2<= '0';
			clr<='0';
			changeDir <='0';
			next_state <= Moving; -- dir set down, go to move state
		else
			emptyList <= '1';
			next_state <= Idle; -- go to idle
			StopSensor1 <= '0';
			StopSensor2<= '0';
	end if;
		
	when Moving =>
		requestFloor<='0';
		StopSensor1<='0';
		StopSensor2<='0';
		if(stop = '1')then
			motor<='1';
		
			next_state <= IncrementDecrementFloorSensor;
		elsif(stop = '0')then
			next_state <= Moving;
		end if;
		
	when IncrementDecrementFloorSensor =>
	  if(changeDir = '1')then
			current_floor <= current_floor + '1';
				
		else
			current_floor <= current_floor -  '1';
			 
		end if;
		doorStart<='1';
		next_state <= StopState;
		StopSensor1 <= '1';
	
	when StopState => 
			if( changeDir = '1')then
				if(up_list(conv_Integer(unsigned(current_floor))) = '1')then
					clr<= '1';
					
					
					requestFloor<='1';
					StopSensor2 <= '1';
					if(doorStart = '1')then
					
					dooropen <='1'; 
					doorclose<='0';
					doorFinish <= '1';
					doorStart<='0';
					next_state <= opennClosed;
					
					end if;
				else
					next_state <= Moving;
					
				end if;
		
			else
				if(down_list(conv_Integer(unsigned(current_floor))) = '1')then 
					
					clr<='1';
					requestFloor<='1';
					StopSensor2<='1';
					if(doorStart = '1')then
					dooropen <='1';
					doorclose<='0';
					doorFinish <= '1';
					doorStart<='0';
					next_state <=opennClosed;
					
					end if;
					
				else
					next_state <= Moving;
				end if;
			end if;
  
	when opennClosed =>
	   motor <= '0';
		
			
		
		if(doorFinish <='1')then
			
			doorclose<= '1';
			dooropen <= '0';
		end if;
		
		if(current_floor = top)then
		next_state <= SetDirection;
	
		changeDir <= not changeDir;
		
		  doorFinish <= '0';
		else
		next_state <= Moving;
		 doorFinish <= '0';
		clr<='0';
		
		
		end if;
		
		end case;
		
		
		
	

end process;








end Behavioral;

