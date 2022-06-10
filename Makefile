WORK=dist
TUNES=durham-gaol klezmorris old-heddon rambling-sailor the-stork windlass
MIDIS=$(foreach name,$(TUNES),$(name).mid)
PDFS=$(foreach name,$(TUNES),$(name).pdf)
MP3S=$(foreach name,$(TUNES),$(name).mp3)
PS=$(foreach name,$(TUNES),$(name).ps)
CLEANFILES=*.mp3 *.mid *.ps *.pdf

dist: $(PDFS) $(MP3S)
	zip $(WORK).zip $^ $(MIDIS)

%.mid, %.mp3: %.abc
	abc2midi "$<" -o "$(basename $@).mid"
	timidity "$(basename $@).mid" -OwS -o - | lame - "$@"

%.pdf: %.abc
	abcm2ps "$<" -O "$(basename $@).ps"
	ps2pdf "$(basename $@).ps" "$(basename $@).pdf"

clean:
	rm -f $(CLEANFILES)

# .SECONDARY: $(MIDIS)
# .INTERMEDIATE: $(PS)
