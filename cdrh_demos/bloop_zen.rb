use_bpm 70

notes = ring(:A, :C, :F, :G)
scales = [:phrygian]
with_fx :echo do
  with_fx :flanger do
    live_loop :chords do
      use_synth :pluck
      base = choose notes
      play base, amp: 0.05
      play_chord chord_degree(:i, base, choose(scales), 5),
        amp: 1.6, attack: 1, decay: 1, decay_level: 0.8, release: 3
      melody base, :phrygian if one_in 4
      sleep 3
    end
  end
end

define :melody do |base, scale|
  use_synth :beep
  play degree(:iii, base, scale), amp: 0.15
  if one_in 2
    sleep 0.5
    play degree(:v, base, scale), amp: 0.15
  end
  sleep 1
  play degree(:i, base, scale), amp: 0.15
end