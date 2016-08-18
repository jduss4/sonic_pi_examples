use_synth :mod_tri

with_fx :ixi_techno do
  live_loop :water do
    play_pattern_timed [:g4, :e4], [1], release: 1
    play_pattern_timed [:g4, :e4, :bb4, :a4], [0.5], release: 1
    play_pattern_timed [:g4, :e4], [1], release: 1
    play_pattern_timed [:g4, :e4, :f4, :g4], [0.5], release: 1
  end
end

live_loop :reflection do
  sleep 8
  sample :ambi_glass_rub, attack: 4, release: 0, pitch: 1, amp: 2
  sample :ambi_glass_rub, rate: -1, release: 4, pitch: 1, amp: 2
  sleep 8
end
