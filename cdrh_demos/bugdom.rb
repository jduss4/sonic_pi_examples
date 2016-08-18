use_synth :piano
use_bpm 35
use_random_seed 2

# add some light percussion
# --x---x---x---x---x
live_loop :cymbals do
  sample :drum_cymbal_soft, lpf: 60
  sleep 0.25/2
  sample :drum_cymbal_soft, lpf: 70
  sleep 0.25/2
  sample :drum_cymbal_hard, lpf: 70
  sleep 0.25/2
  sample :drum_cymbal_soft, lpf: 60
  sleep 0.25/2
end


a_chords = ring(
  chord(:c3, :major),
  chord(:e3, :major),
  chord(:c3, :major),
  chord(:g2, :major7),
)
b_chords = ring(
  chord(:a2, :minor),
  chord(:e2, :minor),
  chord(:eb2, :major),
  chord(:bb2, :major),
  chord(:g2, :major),
)

define :harmony do |pattern|
  case rand_i(6)
  when 0
    sleep 0.5
    play pattern.pick(1)
  when 1
    play pattern.pick(1)
    sleep 0.5
  when 2
    sleep 0.25
    play pattern.pick(1)
    sleep 0.25
  when 3
    play pattern.pick(1)
    sleep 0.25
    play pattern.pick(1)
    sleep 0.25
  else
    sleep 0.5
  end
end

define :play_through_chords do |chords|
  chords.length.times do |i|
    pattern = chords[i]
    in_thread do
      4.times do |j|
        play_chord [pattern[0], pattern[1]], release: 0.75
        sleep 0.25
        play_chord [pattern[0], pattern[2]]
        sleep 0.25
      end
    end
    with_octave 1 do
      4.times do
        harmony(pattern)
      end
    end
  end
end

with_fx :reverb, room: 0.4 do
  with_fx :lpf, cutoff: 80 do
    play_through_chords(a_chords)
    play_through_chords(b_chords)
    play_through_chords(a_chords)
  end
end
