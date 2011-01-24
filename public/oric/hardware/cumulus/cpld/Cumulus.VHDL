-- Cumulus CPLD Core 
-- Top Level Entity
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Cumulus is
    port( 
          CLK: in std_logic;                                -- 32 Mhz input clock
          
                                                            -- Oric Expansion Port Signals
          D: inout std_logic_vector(7 downto 0);            -- 6502 Data Bus                                                            
          A: in std_logic_vector(15 downto 0);              -- 6502 Address Bus
          RnW: in std_logic;                                -- 6502 Read-/Write
          nIRQ: out std_logic;                              -- 6502 /IRQ
          PH2: in std_logic;                                -- 6502 PH2 
          nROMDIS: out std_logic;                           -- Oric ROM Disable
          nMAP: out std_logic;                              -- Oric MAP 
          IO: in std_logic;                                 -- Oric I/O 
          IOCTRL: out std_logic;                            -- Oric I/O Control           
          nHOSTRST: out std_logic;                          -- Oric RESET 
                  
                                                            -- Data Bus Buffer Control Signals
          nOE: out std_logic;                               -- Output Enable
          DIR: out std_logic;                               -- Direction
          
                                                            -- CPLD-MCU Interface
          nMWE: in std_logic;                               -- Write Enable                                                                 
          nMOE: in std_logic;                               -- Output Enable                                                                    
          MFS: in std_logic_vector(2 downto 0);             -- Function Select
          MD:   inout std_logic_vector(7 downto 0);         -- Data Bus     
          nMCRQ: out std_logic;                             -- Command Request
          
                                                            -- Additional MCU Interface Lines
          nRESET: in std_logic;                             -- RESET from MCU
          DSEL: out std_logic_vector(1 downto 0);           -- Drive Select
          SSEL: out std_logic;                              -- Side Select
          
                                                            -- EEPROM Control Lines.
          nECE: out std_logic;                              -- Chip Enable
          nEOE: out std_logic;                              -- Output Enable
          EA13: out std_logic;                              -- Address 
          EA14: out std_logic;
         );
end Cumulus;

architecture Behavioral of Cumulus is

    component WD1793 
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
              MD: inout std_logic_vector(7 downto 0);       -- Data Bus     
              nMCRQ: out std_logic                          -- Command Request
             );
    end component;
    
    signal fdc_nCS: std_logic;                                  
    signal fdc_nRE: std_logic;                              
    signal fdc_nWE: std_logic;                                  
    signal fdc_CLK: std_logic;                                  
    signal fdc_A: std_logic_vector(1 downto 0);         
    signal fdc_DALin: std_logic_vector(7 downto 0); 
    signal fdc_DALout: std_logic_vector(7 downto 0);        
    signal fdc_DRQ: std_logic;                              
    signal fdc_IRQ: std_logic;                                                                                                              
                    
    signal sel: std_logic;                  
    signal u16k: std_logic; 
    signal inECE: std_logic;
    signal inROMDIS: std_logic;
    signal iDIR: std_logic;
    
    -- Control Register 
    signal nROMEN: std_logic;               -- ROM Enable
    signal IRQEN: std_logic;                -- IRQ Enable
    
    signal inMCRQ: std_logic;
    
    signal DBG_cntr: std_logic_vector(1 downto 0);
    signal DBG_signal: std_logic;
    
    signal PH2_1: std_logic;                                
    signal PH2_2: std_logic;                                
    signal PH2_3: std_logic;                                
    signal PH2_old: std_logic_vector(3 downto 0);   
    signal PH2_cntr: std_logic_vector(4 downto 0);
                        
begin

    FDC: WD1793
        port map(fdc_nCS, fdc_nRE, fdc_nWE, fdc_CLK, fdc_A, fdc_DALin, fdc_DALout, fdc_DRQ, fdc_IRQ, nRESET, DBG2, nMWE, nMOE, MFS, MD, inMCRQ);

    -- Reset
    nHOSTRST <= '0' when nRESET = '0' else 'Z';

    -- Select signal (Address Range 031-)
    sel <= '1' when A(7 downto 4) = "0001" and IO = '0' and A(3 downto 2) /= "11"   else '0';

    -- WD1793 Signals
    fdc_A <= A(1 downto 0);
    fdc_nCS <= '0' when sel = '1' and A(3 downto 2) = "00" else '1';
    fdc_nRE <= IO or not RnW;
    fdc_nWE <= IO or RnW;
    fdc_CLK <= not PH2_2;
    fdc_DALin <= D;
            
    -- ORIC Expansion Port Signals
    IOCTRL <= '0' when sel = '1' else 'Z';
    nROMDIS <= '0' when inROMDIS = '0' else 'Z';
    nIRQ <= '0' when fdc_IRQ = '1' and IRQEN = '1' else 'Z';
    
    -- EEPROM Control Signals
    nEOE <= PH2_1 or not RnW;
    u16k <= '1' when (inROMDIS = '0') and (A(14) = '1') and (A(15) = '1') else '0';
    inECE <= not (A(13) and u16k and not nROMEN);
    nECE <= inECE;
    nMAP <= '0' when (PH2_2 and inECE and u16k) = '1' else 'Z'; 
    EA13 <= '0';
    EA14 <= '0';
    
    nMCRQ <= inMCRQ;        
    
    DIR <= iDIR;
    iDIR <= RnW;    
    
    -- Data Bus Control.
    process (iDIR, fdc_DALout, fdc_DRQ, fdc_IRQ, fdc_nRE, A)
    begin 
        if iDIR = '1' then      
            if A(3 downto 2) = "10" then 
                D <= (not fdc_DRQ) & "-------";
            elsif A(3 downto 2) = "01" then 
                D <= (not fdc_IRQ) & "-------"; 
            elsif fdc_nRE = '0' and fdc_nCS = '0' then
                D <= fdc_DALout;            
            else 
                D <= "--------";    
            end if;
        else 
            D <= "ZZZZZZZZ";    
        end if;
    end process;    
    
    nOE <= '0' when sel = '1' and PH2 = '1' else '1';
    
    -- Control Register.
    process (sel, A, RnW, D)
    begin
        if nRESET = '0' then
            nROMEN <= '0';
            DSEL <= "00";
            SSEL <= '0';
            inROMDIS <= '0';
            IRQEN <= '0';       
        elsif falling_edge(PH2_2) then 
            if sel = '1' and A(3 downto 2) = "01" and RnW = '0' then
                nROMEN <= D(7);
                DSEL <= D(6 downto 5);
                SSEL <= D(4);
                inROMDIS <= D(1);
                IRQEN <= D(0);
            end if;
        end if;
    end process;
    
    -- PH2 derived clocks.
    process (PH2, CLK)
    begin
        if nRESET = '0' then
            PH2_cntr <= "00000";
        elsif falling_edge(CLK) then 
            PH2_old <= PH2_old(2 downto 0) & PH2;
            if (PH2_old = "1111") and (PH2 = '0') then 
                PH2_cntr <= "00000";
                PH2_1 <= '1';
            else
                PH2_cntr <= PH2_cntr + 1;               
                if (PH2_cntr = "10000") then 
                    PH2_1 <= '0';
                    PH2_2 <= '1';
                elsif (PH2_cntr = "10111") then 
                    PH2_3 <= '1';
                elsif (PH2_cntr = "11100") then 
                    PH2_2 <= '0';                   
                elsif (PH2_cntr = "11101") then 
                    PH2_3 <= '0';
                end if;
            end if;
        end if;
    end process;        
        
end Behavioral;

