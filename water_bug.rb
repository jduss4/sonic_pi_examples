use_bpm 70

reps = 8.0

chords = ring(
  [:c3, :major],
  [:e3, :major],
  [:c3, :major],
  [:g2, :major],
  [:a2, :minor],
  [:e3, :minor],
  [:eb3, :major],
  [:bb2, :major],
  [:g3, :major]
)

# keep track of the current chord and current playthrough
rep = 0
set = 0

# coordinates chord changes
live_loop :metronome do
  rep = tick
  cue :change_chord
  # if starting the pattern over, send out message
  if rep % chords.length == 0
    set = rep / chords.length
    cue :repeat_pattern
  end
  sleep 4
end


define :amp_by_time do |total_reps, current_rep|
  # create an absolute value chart based on number of reps
  # cut the reps in half for hrep
  #           1
  # y = - (hrep + 1) * | i - hrep | + 1
  #   negative in order to flip chart /\ instead of \/
  #   1 / hrep + 1 stretches to entire time range plus 1 so that no time in range is 0 amp
  #   i - hrep to center the graph within the time range
  #   + 1 to get the amp from 0 to 1
  hrep = total_reps / 2.0
  i = current_rep.to_f
  amp = -(1.0/(hrep+1.0))*(((i+1.0)-hrep).abs)+1.0
end


live_loop :arpeggios do
  sync :change_chord
  sleep 0.25
  pattern = chord chords[rep][0], chords[rep][1], num_octaves: 2
  play_pattern_timed pattern, 0.25, amp: 0.3
  sleep 0.25
  play_pattern_timed pattern.shuffle, 0.25, amp: 0.3
  sleep 0.5
end

live_loop :chimes do
  with_synth :growl do
    with_octave 3 do
      sync :change_chord
      # construct a chord object from the ring ( chord :e3, :major )
      pattern = chord chords[rep][0], chords[rep][1]
      reps.times do |i|
        amp = amp_by_time(reps, i)
        play_chord [pattern[0], pattern[1]], amp: amp
        sleep 0.25
        play_chord [pattern[0], pattern[2]], amp: amp
        sleep 0.25
      end
    end
  end
end

live_loop :glass do
  sync :repeat_pattern
  g = sample :ambi_glass_rub, attack: 3, release: 1, pitch: 1, amp: 0.5, amp_slide: 0.5
  sleep 1
  control g, amp: 1
  sleep 1
  control g, amp: 0.5
  sleep 0.75
  control g, amp: 0
end

live_loop :perc do
  if set >= 0
    sample :loop_breakbeat, beat_stretch: 4
    sleep 4
  else
    sleep 4
  end
end
