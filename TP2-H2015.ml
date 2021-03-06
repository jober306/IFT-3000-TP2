(***********************************************************************)
(* Langages de Programmation: IFT 3000 NRC 11775                       *)
(* TP2 HIVER 2015. Date limite: Vendredi 24 avril � 17h                *) 
(* Implanter un syst�me permettant de chercher des activit�s gratuites *)
(* et payantes en utilisant les donn�es ouvertes de la ville de Qu�bec *)
(***********************************************************************)
(*                                                                     *)
(* NOM: ___________________________ PR�NOM:___________________________ *) 
(* MATRICULE: _____________________ PROGRAMME: _______________________ *)
(*                                                                     *)
(***********************************************************************)
(*                                                                     *)
(* NOM: ___________________________ PR�NOM:___________________________ *) 
(* MATRICULE: _____________________ PROGRAMME: _______________________ *)
(*                                                                     *)
(***********************************************************************)

#load "unix.cma";; (* Charger le module unix *)
#load "str.cma";;  (* Charger le module Str  *)

(* Charger la signature du syst�me d'activit�s *)
#use "TP2-SIG-H2015.mli";;

(********************************************************************) 
(* Implantation du syst�me en utilisant                             *)
(* la programmation orient�e objet                       	    *) 
(********************************************************************)

module Tp2h15 : TP2H15 = struct

  open List
  open Str

	(* Fonctions manipulant les listes et/ou les cha�nes de caract�res *)

	(* appartient : 'a -> 'a list -> bool Retourner si un �l�ment existe ou  *)
	(* non dans une liste                                                    *)

  let appartient e l = exists (fun x -> x = e) l

	(* enlever : 'a -> 'a list -> 'a list Enlever un �l�ment dans une liste *)

  let enlever e l = 
    let (l1, l2) = partition (fun x -> x = e) l
    in l2

	(* remplacer : 'a -> 'a -> 'a list -> 'a list Remplacer un �l�ment par   *)
	(* un autre dans une liste                                               *)

  let remplacer e e' l =
    map (fun x -> (if (x = e) then e' else x)) l 

	(* uniques : string list -> string list Retourner une liste ne contenant *)
	(* que des �l�ments uniques Les cha�nes vides sont �galement enlev�es de *)
	(* la liste ainsi que les espaces inutiles avant et/ou apr�s les cha�nes *)

  let uniques liste =
    let res = ref [] in
    let rec fct l = match l with
     | [] -> !res
     | x:: xs -> if (not (mem x !res) && (x <> "")) then res := (!res)@[String.trim x]; fct xs
    in fct liste

	(* decouper_chaine : string -> string -> string list Retourner une liste *)
	(* en d�coupant une cha�ne selon un s�parateur (p.ex "|")                *)

  let decouper_chaine chaine separateur = split (regexp separateur) chaine

	(* formater_chaine : string list -> string Construire une cha�ne selon   *)
	(* un certain formatage pour les besoins du TP                           *)

  let formater_chaine liste = 
    let res = ref "" in
    let n = (length liste) - 1 in
      for i = 0 to n do
	res := !res ^ ((string_of_int i) ^ " - " ^ (nth liste i) ^ "\n")
      done;
      res := !res ^ ((string_of_int (n +1)) ^ " - Tous \n"); !res

	(* retourner_epoque_secondes : string -> string -> string -> string ->   *)
	(* float Retourne le nombre de secondes depuis l'ann�e 1970 jusqu'� une  *)
	(* date et une heure pr�cises Exemple: let ep =                          *)
	(* retourner_epoque_secondes "2015-03-31" "-" "15:30:00" ":";; val ep :  *)
	(* float = 1427830200.                                                   *)

  let retourner_epoque_secondes (date: string) (sdate: string) (hms: string) (shms: string) =
    let d = decouper_chaine date sdate in
    let yyyy = int_of_string (nth d 0) and mm = int_of_string (nth d 1) and dd = int_of_string (nth d 2) in
    let tmp = decouper_chaine hms shms in
    let h = int_of_string (nth tmp 0) and m = int_of_string (nth tmp 1) and s = int_of_string (nth tmp 2) in
    let eg = { Unix.tm_sec = s; tm_min = m; tm_hour = h; tm_mday = dd; tm_mon = mm -1;
	      tm_year = yyyy -1900; tm_wday = 0; tm_yday = 0; tm_isdst = false } in fst(Unix.mktime eg)

	(* Classes du TP *)

  class activite (lch: string list) (ta: bool) = 
    object(self)
      val type_activite = ta
      val code_session : string = nth lch 0
      val description : string = nth lch 1
      val description_act : string = nth lch 2
      val description_nat : string = nth lch 3
      val nom_cour : string = nth lch 4
      val tarif_base : float = if ta then 0.0 else float_of_string (replace_first (regexp ",") "." (nth lch 5))
      val lieu_1 : string = if ta then nth lch 5 else nth lch 6
      val lieu_2 : string = if ta then nth lch 6 else nth lch 7
      val arrondissement : string = if ta then nth lch 7 else nth lch 8
      val adresse : string = if ta then nth lch 8 else nth lch 9
      val date_deb : string = if ta then nth lch 9 else nth lch 10
      val date_fin : string = if ta then nth lch 10 else nth lch 11
      val jour_semaine : string = if ta then nth lch 11 else nth lch 12
      val heure_deb : string = if ta then nth lch 12 else nth lch 13
      val heure_fin : string = if ta then nth lch 13 else nth lch 14
      method get_type_activite = type_activite
      method get_description = description
      method get_lieu_1 = lieu_1
      method get_adresse = adresse
      method get_jour_semaine = jour_semaine
      method get_arrondissement = arrondissement
      method get_description_nat = description_nat
      method get_tarif_base = tarif_base
      method get_date_deb = date_deb
      method get_heure_deb = heure_deb
      method get_date_fin = date_fin
      method get_heure_fin = heure_fin

			(* M�thode � implanter *)
      
			(* afficher_activite : unit *)
      method afficher_activite = print_string ("Description: " ^ self.get_description 
			^ ".\nType:" ^ self.get_type_activite ^ ".\nLieu " ^ self.get_lieu_1 ^ ".\nAdresse: " 
			^ self.get_adresse ^ ".\nArrondissement:" ^ self.get_arrondissement ^ ".\nDates:" ^ self.date_deb ^ " au " 
			^ self.get_date_fin ^ ".\nJour de la semaine: " ^ self.get_jour_semaine ^ ".\nHeures:" ^ self.get_heure_deb ^ " a " 
			^ self.get_heure_fin ^ ".\n")

    end

  class sysactivites (od: string) =
    object(self)
      val origine_donnees : string = od
      val mutable liste_activites : activite list = []
      method get_origine_donnees = origine_donnees
      method get_liste_activites = liste_activites
      method set_liste_activites (la: activite list) = liste_activites <- la
      method activite_existe (a: activite) = appartient a liste_activites
      method retourner_nbr_activites = length liste_activites

			(* M�thodes � implanter *)
      
			(* ajouter_activite : activite -> unit *)
      method ajouter_activite (a: activite) = self.set_liste_activites (a:: (self.get_liste_activites))

			(* supprimer_activite : activite -> unit *)
      method supprimer_activite (a: activite) = if length self.get_liste_activites = 0 then
				failwith "Le systeme d'activite est vide"
			else
				if activite_existe a then
					enlever a self.get_liste_activites
				else
					 failwith "Le systeme d'activites ne contient pas cette activite"

			(* afficher_systeme_activites : unit *)
      method afficher_systeme_activites = for i = 0 to length self.get_liste_activites do
				(nth self.get_liste_activites i).afficher_activite
			done

			(* lire_fichier : in_channel -> string -> string list list *)
      method lire_fichier (flux: in_channel) (separateur: string) =

			(* trouver_selon_arrondissement : string -> activite list *)
      method trouver_selon_arrondissement (na: string) =
				let arrondissementComparator a = a.get_type_activite = na in 
				if length self.get_liste_activites = 0 then
					failwith "Le systeme d'activite est vide"
				else
					filter arrondissementComparator self.get_liste_activites
					

			(* trouver_selon_type : string -> activite list *)
      method trouver_selon_type (ta: string) = 
				let typeComparator a = a.get_arrondissement = na in  
				if length self.get_liste_activites = 0 then
					failwith "Le systeme d'activite est vide"
				else
					filter arrondissementComparator self.get_liste_activites
					
			(* lister_arrondissements : string list *)
      method lister_arrondissements =
      
			(* lister_types_activites : string list *)
      method lister_types_activites =

    end

  class sysactivites_gratuites (au: string) (od: string) =
    object(self)
      inherit sysactivites od as parent
      val systeme_utilisees : string = au
      method get_systeme_utilisees = systeme_utilisees

			(* M�thodes � implanter *)

			(* ajouter_liste_activites : string list list -> unit *)
      method ajouter_liste_activites (lla: string list list) =

			(* charger_donnees_sysactivites : string -> unit *)
      method charger_donnees_sysactivites (fichier: string) =

			(* trier_activites : int -> unit *)
      method trier_activites (ordre: int) =

      initializer print_string ("Recherche dans un " ^ (self#get_systeme_utilisees) ^ 
				" utilisant les " ^ (parent#get_origine_donnees) ^ ".");
				print_newline()
    end

  class sysactivites_payantes (au: string) (od: string) =
    object(self)
      inherit sysactivites od as parent
      val systeme_utilisees : string = au
      method get_systeme_utilisees = systeme_utilisees

			(* M�thodes � implanter *)

			(* ajouter_liste_activites : string list list -> unit *)
      method ajouter_liste_activites (lla: string list list) =

			(* charger_donnees_sysactivites : string -> unit *)
      method charger_donnees_sysactivites (fichier: string) =

			(* trier_activites : int -> unit *)
      method trier_activites (ordre: int) = 
 
      initializer print_string ("Recherche dans un " ^ (self#get_systeme_utilisees) ^ 
				" utilisant les " ^ (parent#get_origine_donnees) ^ ".");
				print_newline()
    end

  class app_sysactivites (nfa: string) (nfp: string) =
    object(self)
      val nom_fichier_agratuites = nfa
      val nom_fichier_apayantes = nfp

			(* M�thodes � implanter *)

			(* sauvegarder_liste_activites : activite list -> out_channel ->     *)
			(* unit                                                              *)
      method sauvegarder_liste_activites (la: activite list) (flux: out_channel) =

			(* lancer_systeme_activites : unit *)
      method lancer_systeme_activites =

      initializer self#lancer_systeme_activites

    end

end
