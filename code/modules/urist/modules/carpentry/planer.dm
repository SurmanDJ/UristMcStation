//surface planer, for "processing" wood. I know, I know. But nobody else knows anything about carpentry, so it's okay. -Glloyd
/obj/machinery/carpentry
	var/sheets = 0
	var/busy = 0

/obj/machinery/carpentry/planer
	name = "surface planer"
	desc = "A surface planer, used for processing unprocessed wood." //*cringe*
	icon = 'icons/urist/structures&machinery/machinery.dmi'
	icon_state = "planer"
	anchored = 1
	density = 1

/obj/machinery/carpentry/planer/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/stack/material/wood/r_wood))

		if(busy)
			user << "<span class='notice'>The [src] is busy, you can't put in wood yet!.</span>"
			return

		else if(!busy)
			var/obj/item/stack/material/wood/r_wood/R = I
			busy = 1
			sheets = R.amount
			R.use(R.amount)

			user << "<span class='notice'>You feed the unprocessed wood into the [src].</span>"

			flick("planer_animate",src)

			sleep(20)

			var/obj/item/stack/material/wood/W = new /obj/item/stack/material/wood(src.loc)

			W.amount = sheets

			sheets = 0
			busy = 0

	else
		return


/obj/item/stack/material/wood/r_wood
	name = "unprocessed wooden planks"
//	desc = "A bunch of unprocessed wood planks."
	icon = 'icons/urist/items/wood.dmi'
	icon_state = "planks"
	singular_name = "unprocessed wood plank"

/obj/machinery/carpentry/woodprocessor
	name = "wood processor"
	desc = "A machine used for processing wood into cardboard or paper."
	icon = 'icons/urist/structures&machinery/machinery.dmi'
	icon_state = "paper"
	anchored = 1
	density = 1

/obj/machinery/carpentry/woodprocessor/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/stack/material/wood))
		user << "<span class='notice'>You feed the wood into the [src].</span>"

		flick("paper_anim",src)
		var/obj/item/stack/material/wood/R = I
		sheets = R.amount
		R.use(R.amount)

/obj/machinery/carpentry/woodprocessor/attack_hand(mob/user as mob)
	if(sheets)

		var/t = "<B>Wood Processor</B><br><br>Stored Sheers: [sheets]"
		//t += "<A href='?src=\ref[src];on=1'>On</A><br>"
		t += "<A href='?src=\ref[src];on1=Cardboard'>Cardboard</A><br>"
		t += "<A href='?src=\ref[src];on2=PackageWrap'>Package Wrap</A><br>"
		t += "<A href='?src=\ref[src];on3=Paper'>Paper</A><br>"

		user << browse(t, "window=woodprocessor;size=300x300")

	else
		user << "<span class='notice'>There's no wood stored in the [src]!</span>"

/obj/machinery/carpentry/woodprocessor/Topic(href, href_list)
	..()
	if( href_list["on1"] )
		var/obj/item/stack/material/cardboard/W = new /obj/item/stack/material/cardboard(src.loc)
		if(sheets >= 50)
			sheets =- 50
			W.amount = 50
		else
			W.amount = sheets
			return

	if( href_list["on2"] )
		var/obj/item/weapon/packageWrap/W = new /obj/item/weapon/packageWrap(src.loc)
		if(sheets >= 25)
			sheets =- 25
			W.amount = 25
		else
			W.amount = sheets
			return

	if( href_list["on3"] )
		new /obj/item/weapon/paper(src.loc)
		sheets =- 1
		return