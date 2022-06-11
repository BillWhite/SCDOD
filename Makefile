WORK=dist
TUNES=durham-gaol four-lane-end klezmorris old-heddon portobello-hornpipe scotch-polka rambling-sailor the-stork windlass
MIDIS=$(foreach name,$(TUNES),$(name).mid)
PDFS=$(foreach name,$(TUNES),$(name).pdf)
MP3S=$(foreach name,$(TUNES),$(name).mp3)
PS=$(foreach name,$(TUNES),$(name).ps)
CLEANFILES=*.mp3 *.mid *.ps *.pdf dist.zip

dist: dist.zip all.pdf

dist.zip: $(PDFS) $(MP3S) $(MIDIS)
	zip $(WORK).zip $^

all.pdf: $(PDFS)
	pdfjam --frame true --landscape -o all.pdf --nup 2x3 $(PDFS)

%.mid, %.mp3: %.abc
	abc2midi "$<" -o "$(basename $@).mid"
	timidity "$(basename $@).mid" -OwS -o - | lame - "$@"

%.pdf: %.abc
	abcm2ps -l "$<" -O "$(basename $@).ps"
	ps2pdf "$(basename $@).ps" "$(basename $@).pdf"

clean:
	rm -f $(CLEANFILES)

# .SECONDARY: $(MIDIS)
# .INTERMEDIATE: $(PS)
