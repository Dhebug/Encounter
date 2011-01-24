-- Cumulus CPLD Core 
-- WD1793 Entity
-- Copyright 2010 Retromaster
--
--  This file is part of Cumulus CPLD Core.
--
--  Cumulus CPLD Core is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License,
--  or any later version.
--
--  Cumulus CPLD Core is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with Cumulus CPLD Core.  If not, see <http://www.gnu.org/licenses/>.
--

-- Open Issues:
-- 
-- 1. Data Request handling: Asynchronous Set/Resets?
-- 2. Not Ready Status Bit Reset when /MR active.
-- 3. Anything else affected by /MR?
-- 4. Track Register only contains 7 bits.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity WD1793 is
    port(                                               -- CPU Interface 
          nCS: in std_logic;                            -- Chip Select
          nRE: in std_logic;                            -- Read Enable
          nWE: in std_logic;                            -- Write Enable
          CLK: in std_logic;                            -- System Clock
          A: in std_logic_vector(1 downto 0);           -- Register Select
          DALin: in std_logic_vector(7 downto 0);       -- Data Bus
          DALout: out std_logic_vector(7 downto 0);     -- Data Bus
          DRQ: out std_logic;                           -- Data Request
          IRQ: out std_logic;                           -- Interrupt Request
          nMR: in std_logic;                            -- Master Reset

                                                        -- MCU Interface
          nMWE: in std_logic;                           -- Write Enable                                                                 
          nMOE: in std_logic;                           -- Output Enable                                                                    
          MFS: in std_logic_vector(2 downto 0);         -- Function Select
          MD:   inout std_logic_vector(7 downto 0);     -- Data Bus
          nMCRQ: out std_logic                          -- Command Request           
         );
end WD1793;

architecture Behavioral of WD1793 is

    signal data: std_logic_vector(7 downto 0);
    signal track: std_logic_vector(6 downto 0);
    signal sector: std_logic_vector(7 downto 0);
    signal command: std_logic_vector(7 downto 0);
    signal status: std_logic_vector(7 downto 0);
    signal MST: std_logic_vector(6 downto 0);

    -- Status
    signal busy: std_logic;
    signal lostData: std_logic;
    signal dataRequest: std_logic;
    signal commandRequest: std_logic;

begin
   
    --  DRQ Output
    DRQ <= dataRequest;
    
    -- nMCRQ Output
    nMCRQ <= not commandRequest;
       
    -- MCU Command Request
    process(nCS, nWE, A, nMOE, MFS)
    begin
        if rising_edge(CLK) then            
            if nWE = '0' and nCS = '0' and A = "00" then 
                commandRequest <= '1';                   
            elsif nMWE = '0' and MFS = "110" then
                commandRequest <= '0';               
            end if;
        end if;
    end process;
     
    -- Status output.
    process(command, MST, lostData, dataRequest, busy)
    begin   
        if command(7) = '0' or command(7 downto 4) = "1101" then 
            status <= MST & busy;
        else
            status <= MST(6 downto 2) & lostData & dataRequest & busy;
        end if;
    end process;

    process(nCS, nRE, A, track, sector, data, status)
    begin
        -- DAL Read Control. 
        if nCS = '0' and nRE = '0' then
            if A = "00" then
                DALout <= status;
            elsif A = "01" then
                DALout <= "0" & track;
            elsif A = "10" then
                DALout <= sector;
            else 
                DALout <= data;
            end if;
        else
            --DAL <= "ZZZZZZZZ";
            DALout <= "--------";
        end if;
        
    end process;

    process(CLK, nCS, nWE, A, DALin, nMWE, MFS, MD, nRE, commandRequest)
    begin
        
        -- Command Register
        if nMR = '0' then 
            command <= "00000011";  
        elsif rising_edge(CLK) and nCS = '0' and nWE = '0' and A = "00" then         
            command <= DALin;   
        end if;         

        -- Track Register        
        if rising_edge(CLK) then
            if nCS = '0' and nWE = '0' and A = "01" then
                track <= DALin(6 downto 0);
            elsif nMWE = '0' and MFS = "101" then
                track <= MD(6 downto 0);
            end if;
        end if;

        -- Sector Register
        if nMR = '0' then 
            sector <= "00000001";    
        elsif rising_edge(CLK) then
            if nMWE = '0' and MFS = "000" then
                sector <= MD;
            elsif nCS = '0' and nWE = '0' and A = "10" then
                sector <= DALin;                
            end if;
        end if;

        -- Data Register
        if rising_edge(CLK) then
            if nCS = '0' and nWE = '0' and A = "11" then
                data <= DALin;
            elsif nMWE = '0' and MFS = "011" then
                data <= MD;
            end if;
        end if;
                
        -- BUSY handling         
        if rising_edge(CLK) then
            -- Command loaded, busy set.
            if nCS = '0' and nWE = '0' and A = "00" then              
                busy <= '1';
            elsif nMWE = '0' and MFS = "010" then
                busy <= '0';  
            end if;
        end if;

        -- IRQ handling         
        if rising_edge(CLK) then
            if nCS = '0' and nRE = '0' and A = "00" then
                -- Status register read.
                IRQ <= '0';
            elsif nMWE = '0' and MFS = "010" then
                IRQ <= '1';
            end if;
        end if;

        -- Data Request
        if rising_edge(CLK) then 
            if nCS = '0' and (nRE = '0' or nWE = '0') and A = "11" then             
                -- CPU access.
                dataRequest <= '0';
            elsif nMWE = '0' and MFS = "001" then
                 -- Data Request from MCU.
                 dataRequest <= '1';
            end if;
        end if;
          
        -- Lost Data
--        if commandRequest = '1' then
--            lostData <= '0';
--        elsif rising_edge(CLK) and nMWE = '0' and MFS = "001" and dataRequest = '1' then
--            lostData <= '1';
--        end if;  
        lostData <= '0';   

        -- Status Bits
        if rising_edge(CLK) and nMWE = '0' and MFS = "100" then
            MST <= MD(7 downto 1);
        end if;
        
    end process;
    
    -- MCU Bus Read Control
    process(MFS, nMOE, track, data, sector, command)
    begin
        if nMOE = '0' then 
            if MFS = "000" then                
                MD <= command;                   
            elsif MFS = "001" then
                MD <= "0" & track;
            elsif MFS = "010" then
                MD <= sector;
            elsif MFS = "011" then
                MD <= data;
            else 
                MD <= "--------";
            end if;
        else
            MD <= "ZZZZZZZZ";
        end if;     
    end process;        
    
end Behavioral;


