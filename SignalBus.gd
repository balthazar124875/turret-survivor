extends Node


signal enemy_killed(enemy)
signal gold_amount_updated(amount)
signal current_wave_updated(wave)
signal bullet_created(bullet)
signal bullet_destroyed(bullet)
signal player_health_updated(value, source)
signal player_death()
signal on_enemy_hit(enemy, bullet)
signal damage_done(amount, source)
signal heal_done(amount, source)
signal armor_updated(amount, source)
signal orb_amount_increased(nrInner, maxInner, nrOuter, maxOuter)
signal stat_updated(stat, updated_value, difference)
signal augment_recieved(augment)
