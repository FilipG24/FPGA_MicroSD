LIBRARY ieee;
USE ieee.std_logic_1164.all;

---------------------------------Package---------------------------------------
PACKAGE command_package IS

	--------------------------------Command Table----------------------------------
	--		CMD0:		Resets the SD card, which puts the SD card into the SPI mode if 
	-- 				executed when the CS line is low
	--		CMD8:		Makes sure the SD card will function correctly with the supplied
	--					voltage 
	-- 		CMD55: 	Tells the SD card that the next command is an application
	--					specific command rather than a standard command (preparation for
	--					ACMD41 command)
	-- 		ACMD41:	Check when the card is ready for exchange of data
	--		CMD17: 	Reads a block of memory from the card given the block address
	--					(Block address hardcoded)
	-- 
	-- To initialize the SD card for use with SPI, send the bit patterns for CMD0
	-- and CMD8 over the MOSI line. 
	--
	-- To check when the SD card is ready to exchange information, send the bit
	-- patterns for CMD55 and ACMD41 repeatedly until the card replies to the 
	-- ACMD41 command with the bit pattern 00000000 on the MISO line.
	--
	-- To read information from the SD card, send it CMD17, which will read 512
	-- bytes from the specified block address and send them over the MISO line.
	-------------------------------------------------------------------------------
	TYPE std_logic_array IS ARRAY (0 TO 4) OF STD_LOGIC_VECTOR (47 DOWNTO 0);
	CONSTANT command_table: std_logic_array := (
		"010000000000000000000000000000000000000010010101", 	-- CMD0
		"010010000000000000000000000000011010101010000111", 	-- CMD8
		"011101110000000000000000000000000000000000000001", 	-- CMD55
		"011010010100000000000000000000000000000000000001", 	-- ACMD41
		"010100011111111111111111111111111111111100000001" 		-- CMD17
		);

	------------------------Command Bit Retrieval Function-------------------------
	-- Description: Returns the bit pattern for the command wanted.
	-- Arguments: cmd	-	An integer specifying one of the commands:
	--								0: CMD0
	--								1: CMD8
	--								2: CMD55
	--								3: ACMD41
	--								4: CMD17
	-- Returns: The corresponding bit pattern for the specified command.
	-------------------------------------------------------------------------------
	FUNCTION retrieveCommandBits (cmd: INTEGER) RETURN STD_LOGIC_VECTOR;
	
END PACKAGE;

--------------------------------Package Body--------------------------------------
PACKAGE BODY command_package IS
	FUNCTION retrieveCommandBits (cmd: INTEGER) 
	RETURN STD_LOGIC_VECTOR IS
	BEGIN
		RETURN command_table(cmd);
	END FUNCTION;
END PACKAGE BODY;
-------------------------------------------------------------------------------