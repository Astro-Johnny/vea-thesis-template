		when "10" =>	-- ALU/Shifter/Movement ops group
			aluSel <= instr(13 downto 10); -- set ALU op
			shiftSel <= instr(9 downto 7); -- set shift op
			aluCompMuxSel <= '1'; -- Use regArray[?] as operand
	
			if instr(13) = '1' then
				-- Unary or Zero operand operation
				-- NOTE: 1XXX is for INC, DEC, NOT, CLR
				regSel <= instr(5 downto 3);	-- rD
				next_state <= aluOp3; -- this skips reading rS
			else
				-- All other are binary operations
				-- FIXME: This clause includes invalid signals too!
				regSel <= instr(2 downto 0);	-- rS
				next_state <= aluOp1;
			end if;
			-- The rest of opcode is patched to it's respective
			-- devices unmodified, so handling of these ops 
			-- is fairly generic
