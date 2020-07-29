/*
	Humans:
	Adds an exception for gloves, to allow special glove types like the ninja ones.

	Otherwise pretty standard.
*/
<<<<<<< HEAD
/mob/living/carbon/human/UnarmedAttack(atom/A, proximity)
=======

/mob/living/carbon/human/UnarmedAttack(atom/A, proximity, intent = a_intent, attackchain_flags = NONE)
>>>>>>> 81a7542aa6... Merge pull request #12834 from silicons/clickcd_experimental

	if(!has_active_hand()) //can't attack without a hand.
		to_chat(src, "<span class='notice'>You look at your arm and sigh.</span>")
		return

<<<<<<< HEAD
=======
	var/obj/item/bodypart/check_arm = get_active_hand()
	if(check_arm && check_arm.is_disabled() == BODYPART_DISABLED_WOUND)
		to_chat(src, "<span class='warning'>The damage in your [check_arm.name] is preventing you from using it! Get it fixed, or at least splinted!</span>")
		return

	. = attackchain_flags
>>>>>>> 81a7542aa6... Merge pull request #12834 from silicons/clickcd_experimental
	// Special glove functions:
	// If the gloves do anything, have them return 1 to stop
	// normal attack_hand() here.
	var/obj/item/clothing/gloves/G = gloves // not typecast specifically enough in defines
	if(proximity && istype(G))
		. |= G.Touch(A, TRUE)
		if(. & INTERRUPT_UNARMED_ATTACK)
			return

	for(var/datum/mutation/human/HM in dna.mutations)
<<<<<<< HEAD
		override += HM.on_attack_hand(A, proximity)
=======
		. |= HM.on_attack_hand(A, proximity, intent, .)
>>>>>>> 81a7542aa6... Merge pull request #12834 from silicons/clickcd_experimental

	if(. & INTERRUPT_UNARMED_ATTACK)
		return

	SEND_SIGNAL(src, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, A)
<<<<<<< HEAD
	A.attack_hand(src)

//Return TRUE to cancel other attack hand effects that respect it.
/atom/proc/attack_hand(mob/user)
	. = FALSE
=======
	return . | A.attack_hand(src, intent, .)

/atom/proc/attack_hand(mob/user, act_intent = user.a_intent, attackchain_flags)
	SHOULD_NOT_SLEEP(TRUE)
>>>>>>> 81a7542aa6... Merge pull request #12834 from silicons/clickcd_experimental
	if(!(interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_ATTACK_HAND))
		add_fingerprint(user)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_HAND, user) & COMPONENT_NO_ATTACK_HAND)
		return
	. = attackchain_flags
	if(attack_hand_speed && !(. & ATTACK_IGNORE_CLICKDELAY))
		if(!user.CheckActionCooldown(attack_hand_speed))
			return
	if(interaction_flags_atom & INTERACT_ATOM_ATTACK_HAND)
		. = _try_interact(user)
	INVOKE_ASYNC(src, .proc/on_attack_hand, user, act_intent, .)
	if(!(. & ATTACK_IGNORE_ACTION))
		if(attack_hand_unwieldlyness)
			user.DelayNextAction(attack_hand_unwieldlyness, considered_action = attack_hand_is_action)
		else if(attack_hand_is_action)
			user.DelayNextAction()

/atom/proc/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)

//Return a non FALSE value to cancel whatever called this from propagating, if it respects it.
/atom/proc/_try_interact(mob/user)
	if(IsAdminGhost(user))		//admin abuse
		return interact(user)
	if(can_interact(user))
		return interact(user)

/atom/proc/can_interact(mob/user)
	if(!user.can_interact_with(src))
		return FALSE
	if((interaction_flags_atom & INTERACT_ATOM_REQUIRES_DEXTERITY) && !user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return FALSE
	if(!(interaction_flags_atom & INTERACT_ATOM_IGNORE_INCAPACITATED) && user.incapacitated((interaction_flags_atom & INTERACT_ATOM_IGNORE_RESTRAINED), !(interaction_flags_atom & INTERACT_ATOM_CHECK_GRAB)))
		return FALSE
	return TRUE

/atom/ui_status(mob/user)
	. = ..()
	if(!can_interact(user))
		. = min(., UI_UPDATE)

/atom/movable/can_interact(mob/user)
	. = ..()
	if(!.)
		return
	if(!anchored && (interaction_flags_atom & INTERACT_ATOM_REQUIRES_ANCHORED))
		return FALSE

/atom/proc/interact(mob/user)
	if(interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_INTERACT)
		add_hiddenprint(user)
	else
		add_fingerprint(user)
	if(interaction_flags_atom & INTERACT_ATOM_UI_INTERACT)
		ui_interact(user)

/*
/mob/living/carbon/human/RestrainedClickOn(var/atom/A) ---carbons will handle this
	return
*/

/mob/living/carbon/RestrainedClickOn(atom/A)
	return 0

/mob/living/carbon/human/RangedAttack(atom/A, mouseparams)
	. = ..()
	if(gloves)
		var/obj/item/clothing/gloves/G = gloves
		. |= G.Touch(A, FALSE)
		if(. & INTERRUPT_UNARMED_ATTACK)
			return
	if(istype(glasses))
		. |= glasses.ranged_attack(src, A, mouseparams)
		if(. & INTERRUPT_UNARMED_ATTACK)
			return

	for(var/datum/mutation/human/HM in dna.mutations)
		. |= HM.on_ranged_attack(A, mouseparams)

	if(. & INTERRUPT_UNARMED_ATTACK)
		return

	if(isturf(A) && get_dist(src,A) <= 1)
		src.Move_Pulled(A)
		return

/*
	Animals & All Unspecified
*/
/mob/living/UnarmedAttack(atom/A)
	A.attack_animal(src)

/atom/proc/attack_animal(mob/user)
	SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_ANIMAL, user)

/mob/living/RestrainedClickOn(atom/A)
	return

/*
	Monkeys
*/
<<<<<<< HEAD
/mob/living/carbon/monkey/UnarmedAttack(atom/A)
	A.attack_paw(src)
=======
/mob/living/carbon/monkey/UnarmedAttack(atom/A, proximity, intent = a_intent, flags = NONE)
	if(!CheckActionCooldown(CLICK_CD_MELEE))
		return
	return !isnull(A.attack_paw(src, intent, flags))
>>>>>>> 81a7542aa6... Merge pull request #12834 from silicons/clickcd_experimental

/atom/proc/attack_paw(mob/user)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_PAW, user) & COMPONENT_NO_ATTACK_HAND)
		return TRUE
	return FALSE

/*
	Monkey RestrainedClickOn() was apparently the
	one and only use of all of the restrained click code
	(except to stop you from doing things while handcuffed);
	moving it here instead of various hand_p's has simplified
	things considerably
*/
/mob/living/carbon/monkey/RestrainedClickOn(atom/A)
	if(..())
		return
	if(a_intent != INTENT_HARM || !ismob(A))
		return
	if(is_muzzled())
		return
	if(!CheckActionCooldown(CLICK_CD_MELEE))
		return
	var/mob/living/carbon/ML = A
	if(istype(ML))
		var/dam_zone = pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
		var/obj/item/bodypart/affecting = null
		if(ishuman(ML))
			var/mob/living/carbon/human/H = ML
			affecting = H.get_bodypart(ran_zone(dam_zone))
		var/armor = ML.run_armor_check(affecting, "melee")
		if(prob(75))
			ML.apply_damage(rand(1,3), BRUTE, affecting, armor)
			ML.visible_message("<span class='danger'>[name] bites [ML]!</span>", \
							"<span class='userdanger'>[name] bites [ML]!</span>")
			if(armor >= 2)
				return
			for(var/thing in diseases)
				var/datum/disease/D = thing
				ML.ForceContractDisease(D)
		else
			ML.visible_message("<span class='danger'>[src] has attempted to bite [ML]!</span>")
	DelayNextAction()

/*
	Aliens
	Defaults to same as monkey in most places
*/
/mob/living/carbon/alien/UnarmedAttack(atom/A)
	A.attack_alien(src)

/atom/proc/attack_alien(mob/living/carbon/alien/user)
	attack_paw(user)
	return

/mob/living/carbon/alien/RestrainedClickOn(atom/A)
	return

// Babby aliens
/mob/living/carbon/alien/larva/UnarmedAttack(atom/A)
	A.attack_larva(src)
/atom/proc/attack_larva(mob/user)
	return


/*
	Slimes
	Nothing happening here
*/
/mob/living/simple_animal/slime/UnarmedAttack(atom/A)
	A.attack_slime(src)
/atom/proc/attack_slime(mob/user)
	return
/mob/living/simple_animal/slime/RestrainedClickOn(atom/A)
	return


/*
	Drones
*/
/mob/living/simple_animal/drone/UnarmedAttack(atom/A)
	A.attack_drone(src)

/atom/proc/attack_drone(mob/living/simple_animal/drone/user)
	attack_hand(user) //defaults to attack_hand. Override it when you don't want drones to do same stuff as humans.

/mob/living/simple_animal/slime/RestrainedClickOn(atom/A)
	return


/*
	True Devil
*/

/mob/living/carbon/true_devil/UnarmedAttack(atom/A, proximity)
	A.attack_hand(src)

/*
	Brain
*/

/mob/living/brain/UnarmedAttack(atom/A)//Stops runtimes due to attack_animal being the default
	return


/*
	pAI
*/

/mob/living/silicon/pai/UnarmedAttack(atom/A)//Stops runtimes due to attack_animal being the default
	return


/*
	Simple animals
*/

/mob/living/simple_animal/UnarmedAttack(atom/A, proximity)
	if(!dextrous)
		return ..()
	if(!ismob(A))
		A.attack_hand(src)
		update_inv_hands()


/*
	Hostile animals
*/

/mob/living/simple_animal/hostile/UnarmedAttack(atom/A)
	target = A
	if(dextrous && !ismob(A))
		return ..()
	else
		AttackingTarget()



/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/dead/new_player/ClickOn()
	return
