use_bpm 50

main_notes = [47, 50, 54, 60, 62]
chords = [:major, :dom7]


in_thread(name: :blips) do
  with_fx :reverb do
    loop do
      play_chord chord(choose(main_notes), choose(chords))
      sleep 3
    end
  end
end

in_thread(name: :tune) do
  use_synth :dark_ambience
  with_fx :flanger do
    loop do
      play choose(main_notes), release: 2, amp: 1.5
      sleep 2
    end
  end
end


