<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<HTML lang=fr dir=ltr>
	<HEAD>
		<meta name="robots" content="noindex">
		<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1">
		<title>OSDK - Ym2Mym</title>
		<link href="documentation.css" rel="stylesheet" type="text/css">
	</HEAD>

	<BODY>

<hr>
<A href="documentation.htm"><img src="arrow_back.gif"></A>
<img src="pics/osdk_logo_small.png">
<hr>

		<h1>Ym2Mym</h1>

<p id=chapter>Description</p>

<div class="article">
The Oric computers are equiped with a AY-3-8912 sound chip.
<br>
<br>
This component can be found in multiple variants in many other systems such as the MSX, Amstrad CPC, Atari ST, some of the Sinclair Spectrum machines, among other.
<br>
<br>
It is an unfortunate fact that only very few Oric games had music back in the 80ies, but this can be fortunately fixed today thanks to the huge catalog of available musics on the other machines!
</div>


<p id=chapter>YM Files</p>

<div class="article">
The YM file format was originally designed by Arnaud Carré as a way to record Atari ST musics to make them replayable on a PC.
<br>
<br>
Technically a YM file is simply a register dump of the music: A program captured 50 times per second the content of the values sent to the YM chip. 
With 14 registers to record, 50 times per second, it means that one second of music takes 700 bytes, so roughly 42kbytes per minute of music.
<br>
<br>
The chosen solution was to store the data sorted by register number, and then compress the whole file with the LHA compressor, which typically reduces the music files to less than 10kb even for very long musics.
<br>
<br>
Unfortunatelly this means that the music file must be entirelly decompressed before it can be used, which makes it unusable on 8bit machines. That's where the MYM format comes in.
</div>


<p id=chapter>MYM Files</p>

<div class="article">
The MYM files are basically YM files that have been uncompressed and recompressed in a way that allows for partial decompression over time. The efficiency is not as good, but at least it works.
<br>
<br>
Ym2MYm can be used to perform this conversion. It will work only on YM files that do not use special timer effects such as digidrums or sid.
</div>

<p id=chapter>Retuning</p>

<p>There are multiple machines using variants of the AY or YM soudchip, but they don't all use the same clock frequency: If you attempt at replaying a music made originally for another machine, and if it had a different clock, the resulting music will play at a different frequency than the original.
</p>
<p>
If you want to preserve the original sound of the music, it is necessary to retune the register values so they compensate for the difference in frequency. In YM2MYM this is simply achieved by declaring the frequency of the source machine (using -r) and the one of the target machine (using -t).
</p>
<p>
Originally the tool was made to play Atari ST musics on the Oric computers, so by default, the tool will assume a 2MHz source clock and 1MHz target clock, but you can specify any arbitrary value.
</p>
<p>
For reference, here is the known clock speed of a few machines:
</p>
<ul>
<li>Oric: 1MHz
<li>Amstrad CPC: 1MHz
<li>Sinclair Spectrum: 1.7734MHz
<li>Atari ST: 2MHz
</ul>
<p>
Due to the fact that the soundchip registers have a specific range of valid values (from 0 to 4095 for the notes, from 0 to 65535 for the enveloppe duration and from 0 to 31 for the noise frequency), it is possible that the retuning results in a value being out of range, which obviously will also impact how the music sounds.
</p>
<p>
When this happen, the tool will display some warning message indicating how often the truncation happened, and how bad the truncation was. If you are lucky you will not notice, but the tool will also indicate at which position the worse case happened, so you can eventually tweak the tune.
</p>
<p>
Example:
</p>
<pre>
Found some clamping issues when retuning "data\Great Giana Sisters 1 - title.ym"'s frequency from 1MHz to 1.7734MHz at 50fps:
- 'Channel A' overflowed 560 times (maximum was 5077 [over 4095] at time position 3'17" (frame 9858)
- 'Noise Channel' overflowed 5070 times (maximum was 54 [over 31] at time position 0'27" (frame 1376)
</pre>
<p>
As a final note, we'd like to point out that if technically speaking the AY and YM chips are register compatible and behave mostly the same, they are not identical chip, so in practice the same music can sound different depending on how it uses volume changes and enveloppes:
</p>
<ul>
<li>Note transitions seem smoother on the YM (thanks to the higher internal accuracy)
<li>The output from the AY is louder.
<li>The YM output is cleaner
</ul>


<p id=chapter>Utilisation</p>

<p>To transform a binary file as a texte file:
</p>
<pre>
%OSDK%\bin\Ym2Mym [switches] source.ym destination.mym [load adress] [header name]
</pre>


<p id=chapter>Switches</p>

<ul>

    <li>-rn Reference Clock
		<br>
        <ul>
            <li>-r1        => Oric, Amstrad CPC</li>
            <li>-r1.773400 => ZX Spectrum</li>
            <li>-r2        => Atari ST [default]</li>
    		<br>
		</ul>
	</li>

    <li>-tn Target Clock
    	<ul>
            <li>-t0        => Use Reference (no retune)</li>
            <li>-t1.0      => Oric, Amstrad CPC [default]</li>
            <li>-t1.773400 => ZX Spectrum</li>
            <li>-t2.0      => Atari ST</li>
            <br>
    	</ul>
   	</li>

	<li>-vn Verbosity
		<br>
		Enables or disable the printing of informative messages.
		<ul>
			<li>-v0 => Silent [default]</li>
			<li>-v1 => Shows information about what Ym2Mym is doing</li>
			<br>
		</ul>
	</li>

	<li>-hn Header
		<br>
		Adds a tape compatible header
		<ul>
			<li>-h0 => No tape header [default]</li>
			<li>-h1 => Use tape header (requires a start address and a name)</li>
			<br>
		</ul>
	</li>

	<li>-mn Max size
		<br>
		The MYM replay routine generally is provided with a limited size for the music. Using this switch you can force Ym2Mym to refuse to convert a music and output an error message if the final compressed file gets larger than the specified number.
		<ul>
			<li>-m0 => No size limit [default]</li>
			<li>-m1234 => Outputs an error if the exported size is too large</li>
			<br>
		</ul>
	</li>

	<li>-dxn  Duration mode
		<br>
		You can use this flag to force the tool to truncate the music after a specific number of frames (there's 50 frames in a second). Use -dt to truncate, and -df to fade.
		<ul>
			<li>-dt1234 => Truncate at frame 1234</li>
			<li>-df1234 => Fade out at frame 1234</li>
			<br>
		</ul>
	</li>
</ul>

<br>

<p id=chapter>History</p>

<p id=dateentry>Version 1.8</p>
<ul>
	<li>Modified the semantics of the -t flag (now means Target Frequency) and added a -r flag (Reference Frequency) which both accept decimal values (like 1.0, 2.0 or 1.77340)</li>
</ul>

<p id=dateentry>Version 1.7</p>
<ul>
	<li>Added a -f flag that can be used to export the music to WAV format instead of MYM</li>
</ul>


<p id=dateentry>Version 1.6</p>
<ul>
	<li>Added the -dt/-df flags to shorten musics</li>
</ul>

<p id=dateentry>Version 1.5</p>
<ul>
	<li>The verbose mode (-v1) now display the embedded informations such as author name, song name, and extra comments</li>
	<li>Interleave register format is now also supported</li>
</ul>

<p id=dateentry>Version 1.4</p>
<ul>
	<li>Fixed a stupid bug of signed data added in version 1.2</li>
</ul>

<p id=dateentry>Version 1.3 (Broken!)</p>
<ul>
	<li>Added a -m flag to check if the exported file fits a maximum size</li>
</ul>

<p id=dateentry>Version 1.2 (Broken!)</p>
<ul>
	<li>Added a -v flag to enable/disable verbosity</li>
	<li>Added a -h flag to add a tape compatible header</li>
</ul>

<p id=dateentry>Version 1.1</p>
<ul>
	<li>The tool is now able to extract LHA compressed YM files directly, should make the process much easier :)</li>
</ul>

<p id=dateentry>Version 1.0</p>
<ul>
	<li>Added support for retuning (Atari ST songs are at 2MHz, Amstrad ones at 1MHz)</li>
	<li>Added rude support for YM6 format (also skips most of the header)</li>
</ul>

<p id=dateentry>Version 0.2</p>
<ul>
	<li>Added a rude YM5 loader. Skips most of the header.</li>
</ul>

<p id=dateentry>Version 0.1</p>
<ul>
	<li>First version by Marq/Lieves!Tuore & Fit (marq@iki.fi)</li>
</ul>


<hr>
<A href="documentation.htm"><img src="arrow_back.gif"></A>
<img src="pics/osdk_logo_small.png">
<hr>


	</BODY>
</HTML>

