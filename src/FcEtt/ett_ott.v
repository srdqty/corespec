Require Import Metalib.Metatheory.
(** syntax *)
Definition tmvar := var. (*r variables *)
Definition covar := var. (*r coercion variables *)
Definition datacon := atom.
Definition const := atom.
Definition tyfam := atom.
Definition index := nat. (*r indices *)

Inductive role : Set :=  (*r Role *)
 | Nom : role
 | Rep : role.

Inductive relflag : Set :=  (*r relevance flag *)
 | Rel : relflag
 | Irrel : relflag.

Inductive constraint : Set :=  (*r props *)
 | Eq (a:tm) (b:tm) (A:tm) (R:role)
with tm : Set :=  (*r types and kinds *)
 | a_Star : tm
 | a_Var_b (_:nat)
 | a_Var_f (x:tmvar)
 | a_Abs (rho:relflag) (A:tm) (R:role) (b:tm)
 | a_UAbs (rho:relflag) (b:tm)
 | a_App (a:tm) (rho:relflag) (b:tm)
 | a_Fam (F:tyfam)
 | a_Const (T:const)
 | a_Pi (rho:relflag) (A:tm) (R:role) (B:tm)
 | a_Conv (a:tm) (g:co)
 | a_CPi (phi:constraint) (B:tm)
 | a_CAbs (phi:constraint) (b:tm)
 | a_UCAbs (b:tm)
 | a_CApp (a:tm) (g:co)
 | a_Bullet : tm
 | a_DataCon (K:datacon)
 | a_Case (a:tm) (brs5:brs)
with brs : Set :=  (*r case branches *)
 | br_None : brs
 | br_One (K:datacon) (a:tm) (brs5:brs)
with co : Set :=  (*r explicit coercions *)
 | g_Triv : co
 | g_Var_b (_:nat)
 | g_Var_f (c:covar)
 | g_Beta (a:tm) (b:tm)
 | g_Refl (a:tm)
 | g_Refl2 (a:tm) (b:tm) (g:co)
 | g_Sym (g:co)
 | g_Trans (g1:co) (g2:co)
 | g_PiCong (rho:relflag) (g1:co) (g2:co)
 | g_AbsCong (rho:relflag) (g1:co) (g2:co)
 | g_AppCong (g1:co) (rho:relflag) (g2:co)
 | g_PiFst (g:co)
 | g_CPiFst (g:co)
 | g_IsoSnd (g:co)
 | g_PiSnd (g1:co) (g2:co)
 | g_CPiCong (g1:co) (g3:co)
 | g_CAbsCong (g1:co) (g3:co) (g4:co)
 | g_CAppCong (g:co) (g1:co) (g2:co)
 | g_CPiSnd (g:co) (g1:co) (g2:co)
 | g_Cast (g1:co) (g2:co)
 | g_EqCong (g1:co) (A:tm) (R:role) (g2:co)
 | g_IsoConv (phi1:constraint) (phi2:constraint) (g:co)
 | g_Eta (a:tm)
 | g_Left (g:co) (g':co)
 | g_Right (g:co) (g':co).

Inductive sort : Set :=  (*r binding classifier *)
 | Tm (A:tm) (R:role)
 | Co (phi:constraint).

Inductive sig_sort : Set :=  (*r signature classifier *)
 | Cs (A:tm)
 | Ax (a:tm) (A:tm) (R:role).

Definition context : Set := list ( atom * sort ).

Definition sig : Set := list (atom * sig_sort).

Definition available_props : Type := atoms.

(* EXPERIMENTAL *)
(** auxiliary functions on the new list types *)
(** library functions *)
(** subrules *)
(** arities *)
(** opening up abstractions *)
Fixpoint open_co_wrt_co_rec (k:nat) (g_5:co) (g__6:co) {struct g__6}: co :=
  match g__6 with
  | g_Triv => g_Triv 
  | (g_Var_b nat) => 
      match lt_eq_lt_dec nat k with
        | inleft (left _) => g_Var_b nat
        | inleft (right _) => g_5
        | inright _ => g_Var_b (nat - 1)
      end
  | (g_Var_f c) => g_Var_f c
  | (g_Beta a b) => g_Beta (open_tm_wrt_co_rec k g_5 a) (open_tm_wrt_co_rec k g_5 b)
  | (g_Refl a) => g_Refl (open_tm_wrt_co_rec k g_5 a)
  | (g_Refl2 a b g) => g_Refl2 (open_tm_wrt_co_rec k g_5 a) (open_tm_wrt_co_rec k g_5 b) (open_co_wrt_co_rec k g_5 g)
  | (g_Sym g) => g_Sym (open_co_wrt_co_rec k g_5 g)
  | (g_Trans g1 g2) => g_Trans (open_co_wrt_co_rec k g_5 g1) (open_co_wrt_co_rec k g_5 g2)
  | (g_PiCong rho g1 g2) => g_PiCong rho (open_co_wrt_co_rec k g_5 g1) (open_co_wrt_co_rec k g_5 g2)
  | (g_AbsCong rho g1 g2) => g_AbsCong rho (open_co_wrt_co_rec k g_5 g1) (open_co_wrt_co_rec k g_5 g2)
  | (g_AppCong g1 rho g2) => g_AppCong (open_co_wrt_co_rec k g_5 g1) rho (open_co_wrt_co_rec k g_5 g2)
  | (g_PiFst g) => g_PiFst (open_co_wrt_co_rec k g_5 g)
  | (g_CPiFst g) => g_CPiFst (open_co_wrt_co_rec k g_5 g)
  | (g_IsoSnd g) => g_IsoSnd (open_co_wrt_co_rec k g_5 g)
  | (g_PiSnd g1 g2) => g_PiSnd (open_co_wrt_co_rec k g_5 g1) (open_co_wrt_co_rec k g_5 g2)
  | (g_CPiCong g1 g3) => g_CPiCong (open_co_wrt_co_rec k g_5 g1) (open_co_wrt_co_rec (S k) g_5 g3)
  | (g_CAbsCong g1 g3 g4) => g_CAbsCong (open_co_wrt_co_rec k g_5 g1) (open_co_wrt_co_rec (S k) g_5 g3) (open_co_wrt_co_rec k g_5 g4)
  | (g_CAppCong g g1 g2) => g_CAppCong (open_co_wrt_co_rec k g_5 g) (open_co_wrt_co_rec k g_5 g1) (open_co_wrt_co_rec k g_5 g2)
  | (g_CPiSnd g g1 g2) => g_CPiSnd (open_co_wrt_co_rec k g_5 g) (open_co_wrt_co_rec k g_5 g1) (open_co_wrt_co_rec k g_5 g2)
  | (g_Cast g1 g2) => g_Cast (open_co_wrt_co_rec k g_5 g1) (open_co_wrt_co_rec k g_5 g2)
  | (g_EqCong g1 A R g2) => g_EqCong (open_co_wrt_co_rec k g_5 g1) (open_tm_wrt_co_rec k g_5 A) R (open_co_wrt_co_rec k g_5 g2)
  | (g_IsoConv phi1 phi2 g) => g_IsoConv (open_constraint_wrt_co_rec k g_5 phi1) (open_constraint_wrt_co_rec k g_5 phi2) (open_co_wrt_co_rec k g_5 g)
  | (g_Eta a) => g_Eta (open_tm_wrt_co_rec k g_5 a)
  | (g_Left g g') => g_Left (open_co_wrt_co_rec k g_5 g) (open_co_wrt_co_rec k g_5 g')
  | (g_Right g g') => g_Right (open_co_wrt_co_rec k g_5 g) (open_co_wrt_co_rec k g_5 g')
end
with open_brs_wrt_co_rec (k:nat) (g5:co) (brs_6:brs) {struct brs_6}: brs :=
  match brs_6 with
  | br_None => br_None 
  | (br_One K a brs5) => br_One K (open_tm_wrt_co_rec k g5 a) (open_brs_wrt_co_rec k g5 brs5)
end
with open_tm_wrt_co_rec (k:nat) (g5:co) (a5:tm) {struct a5}: tm :=
  match a5 with
  | a_Star => a_Star 
  | (a_Var_b nat) => a_Var_b nat
  | (a_Var_f x) => a_Var_f x
  | (a_Abs rho A R b) => a_Abs rho (open_tm_wrt_co_rec k g5 A) R (open_tm_wrt_co_rec k g5 b)
  | (a_UAbs rho b) => a_UAbs rho (open_tm_wrt_co_rec k g5 b)
  | (a_App a rho b) => a_App (open_tm_wrt_co_rec k g5 a) rho (open_tm_wrt_co_rec k g5 b)
  | (a_Fam F) => a_Fam F
  | (a_Const T) => a_Const T
  | (a_Pi rho A R B) => a_Pi rho (open_tm_wrt_co_rec k g5 A) R (open_tm_wrt_co_rec k g5 B)
  | (a_Conv a g) => a_Conv (open_tm_wrt_co_rec k g5 a) (open_co_wrt_co_rec k g5 g)
  | (a_CPi phi B) => a_CPi (open_constraint_wrt_co_rec k g5 phi) (open_tm_wrt_co_rec (S k) g5 B)
  | (a_CAbs phi b) => a_CAbs (open_constraint_wrt_co_rec k g5 phi) (open_tm_wrt_co_rec (S k) g5 b)
  | (a_UCAbs b) => a_UCAbs (open_tm_wrt_co_rec (S k) g5 b)
  | (a_CApp a g) => a_CApp (open_tm_wrt_co_rec k g5 a) (open_co_wrt_co_rec k g5 g)
  | a_Bullet => a_Bullet 
  | (a_DataCon K) => a_DataCon K
  | (a_Case a brs5) => a_Case (open_tm_wrt_co_rec k g5 a) (open_brs_wrt_co_rec k g5 brs5)
end
with open_constraint_wrt_co_rec (k:nat) (g5:co) (phi5:constraint) : constraint :=
  match phi5 with
  | (Eq a b A R) => Eq (open_tm_wrt_co_rec k g5 a) (open_tm_wrt_co_rec k g5 b) (open_tm_wrt_co_rec k g5 A) R
end.

Fixpoint open_co_wrt_tm_rec (k:nat) (a5:tm) (g_5:co) {struct g_5}: co :=
  match g_5 with
  | g_Triv => g_Triv 
  | (g_Var_b nat) => g_Var_b nat
  | (g_Var_f c) => g_Var_f c
  | (g_Beta a b) => g_Beta (open_tm_wrt_tm_rec k a5 a) (open_tm_wrt_tm_rec k a5 b)
  | (g_Refl a) => g_Refl (open_tm_wrt_tm_rec k a5 a)
  | (g_Refl2 a b g) => g_Refl2 (open_tm_wrt_tm_rec k a5 a) (open_tm_wrt_tm_rec k a5 b) (open_co_wrt_tm_rec k a5 g)
  | (g_Sym g) => g_Sym (open_co_wrt_tm_rec k a5 g)
  | (g_Trans g1 g2) => g_Trans (open_co_wrt_tm_rec k a5 g1) (open_co_wrt_tm_rec k a5 g2)
  | (g_PiCong rho g1 g2) => g_PiCong rho (open_co_wrt_tm_rec k a5 g1) (open_co_wrt_tm_rec (S k) a5 g2)
  | (g_AbsCong rho g1 g2) => g_AbsCong rho (open_co_wrt_tm_rec k a5 g1) (open_co_wrt_tm_rec (S k) a5 g2)
  | (g_AppCong g1 rho g2) => g_AppCong (open_co_wrt_tm_rec k a5 g1) rho (open_co_wrt_tm_rec k a5 g2)
  | (g_PiFst g) => g_PiFst (open_co_wrt_tm_rec k a5 g)
  | (g_CPiFst g) => g_CPiFst (open_co_wrt_tm_rec k a5 g)
  | (g_IsoSnd g) => g_IsoSnd (open_co_wrt_tm_rec k a5 g)
  | (g_PiSnd g1 g2) => g_PiSnd (open_co_wrt_tm_rec k a5 g1) (open_co_wrt_tm_rec k a5 g2)
  | (g_CPiCong g1 g3) => g_CPiCong (open_co_wrt_tm_rec k a5 g1) (open_co_wrt_tm_rec k a5 g3)
  | (g_CAbsCong g1 g3 g4) => g_CAbsCong (open_co_wrt_tm_rec k a5 g1) (open_co_wrt_tm_rec k a5 g3) (open_co_wrt_tm_rec k a5 g4)
  | (g_CAppCong g g1 g2) => g_CAppCong (open_co_wrt_tm_rec k a5 g) (open_co_wrt_tm_rec k a5 g1) (open_co_wrt_tm_rec k a5 g2)
  | (g_CPiSnd g g1 g2) => g_CPiSnd (open_co_wrt_tm_rec k a5 g) (open_co_wrt_tm_rec k a5 g1) (open_co_wrt_tm_rec k a5 g2)
  | (g_Cast g1 g2) => g_Cast (open_co_wrt_tm_rec k a5 g1) (open_co_wrt_tm_rec k a5 g2)
  | (g_EqCong g1 A R g2) => g_EqCong (open_co_wrt_tm_rec k a5 g1) (open_tm_wrt_tm_rec k a5 A) R (open_co_wrt_tm_rec k a5 g2)
  | (g_IsoConv phi1 phi2 g) => g_IsoConv (open_constraint_wrt_tm_rec k a5 phi1) (open_constraint_wrt_tm_rec k a5 phi2) (open_co_wrt_tm_rec k a5 g)
  | (g_Eta a) => g_Eta (open_tm_wrt_tm_rec k a5 a)
  | (g_Left g g') => g_Left (open_co_wrt_tm_rec k a5 g) (open_co_wrt_tm_rec k a5 g')
  | (g_Right g g') => g_Right (open_co_wrt_tm_rec k a5 g) (open_co_wrt_tm_rec k a5 g')
end
with open_brs_wrt_tm_rec (k:nat) (a5:tm) (brs_6:brs) {struct brs_6}: brs :=
  match brs_6 with
  | br_None => br_None 
  | (br_One K a brs5) => br_One K (open_tm_wrt_tm_rec k a5 a) (open_brs_wrt_tm_rec k a5 brs5)
end
with open_tm_wrt_tm_rec (k:nat) (a5:tm) (a_6:tm) {struct a_6}: tm :=
  match a_6 with
  | a_Star => a_Star 
  | (a_Var_b nat) => 
      match lt_eq_lt_dec nat k with
        | inleft (left _) => a_Var_b nat
        | inleft (right _) => a5
        | inright _ => a_Var_b (nat - 1)
      end
  | (a_Var_f x) => a_Var_f x
  | (a_Abs rho A R b) => a_Abs rho (open_tm_wrt_tm_rec k a5 A) R (open_tm_wrt_tm_rec (S k) a5 b)
  | (a_UAbs rho b) => a_UAbs rho (open_tm_wrt_tm_rec (S k) a5 b)
  | (a_App a rho b) => a_App (open_tm_wrt_tm_rec k a5 a) rho (open_tm_wrt_tm_rec k a5 b)
  | (a_Fam F) => a_Fam F
  | (a_Const T) => a_Const T
  | (a_Pi rho A R B) => a_Pi rho (open_tm_wrt_tm_rec k a5 A) R (open_tm_wrt_tm_rec (S k) a5 B)
  | (a_Conv a g) => a_Conv (open_tm_wrt_tm_rec k a5 a) (open_co_wrt_tm_rec k a5 g)
  | (a_CPi phi B) => a_CPi (open_constraint_wrt_tm_rec k a5 phi) (open_tm_wrt_tm_rec k a5 B)
  | (a_CAbs phi b) => a_CAbs (open_constraint_wrt_tm_rec k a5 phi) (open_tm_wrt_tm_rec k a5 b)
  | (a_UCAbs b) => a_UCAbs (open_tm_wrt_tm_rec k a5 b)
  | (a_CApp a g) => a_CApp (open_tm_wrt_tm_rec k a5 a) (open_co_wrt_tm_rec k a5 g)
  | a_Bullet => a_Bullet 
  | (a_DataCon K) => a_DataCon K
  | (a_Case a brs5) => a_Case (open_tm_wrt_tm_rec k a5 a) (open_brs_wrt_tm_rec k a5 brs5)
end
with open_constraint_wrt_tm_rec (k:nat) (a5:tm) (phi5:constraint) : constraint :=
  match phi5 with
  | (Eq a b A R) => Eq (open_tm_wrt_tm_rec k a5 a) (open_tm_wrt_tm_rec k a5 b) (open_tm_wrt_tm_rec k a5 A) R
end.

Definition open_sort_wrt_co_rec (k:nat) (g5:co) (sort5:sort) : sort :=
  match sort5 with
  | (Tm A R) => Tm (open_tm_wrt_co_rec k g5 A) R
  | (Co phi) => Co (open_constraint_wrt_co_rec k g5 phi)
end.

Definition open_sig_sort_wrt_co_rec (k:nat) (g5:co) (sig_sort5:sig_sort) : sig_sort :=
  match sig_sort5 with
  | (Cs A) => Cs (open_tm_wrt_co_rec k g5 A)
  | (Ax a A R) => Ax (open_tm_wrt_co_rec k g5 a) (open_tm_wrt_co_rec k g5 A) R
end.

Definition open_sig_sort_wrt_tm_rec (k:nat) (a5:tm) (sig_sort5:sig_sort) : sig_sort :=
  match sig_sort5 with
  | (Cs A) => Cs (open_tm_wrt_tm_rec k a5 A)
  | (Ax a A R) => Ax (open_tm_wrt_tm_rec k a5 a) (open_tm_wrt_tm_rec k a5 A) R
end.

Definition open_sort_wrt_tm_rec (k:nat) (a5:tm) (sort5:sort) : sort :=
  match sort5 with
  | (Tm A R) => Tm (open_tm_wrt_tm_rec k a5 A) R
  | (Co phi) => Co (open_constraint_wrt_tm_rec k a5 phi)
end.

Definition open_brs_wrt_co g5 brs_6 := open_brs_wrt_co_rec 0 brs_6 g5.

Definition open_tm_wrt_co g5 a5 := open_tm_wrt_co_rec 0 a5 g5.

Definition open_brs_wrt_tm a5 brs_6 := open_brs_wrt_tm_rec 0 brs_6 a5.

Definition open_sort_wrt_co g5 sort5 := open_sort_wrt_co_rec 0 sort5 g5.

Definition open_sig_sort_wrt_co g5 sig_sort5 := open_sig_sort_wrt_co_rec 0 sig_sort5 g5.

Definition open_co_wrt_co g_5 g__6 := open_co_wrt_co_rec 0 g__6 g_5.

Definition open_sig_sort_wrt_tm a5 sig_sort5 := open_sig_sort_wrt_tm_rec 0 sig_sort5 a5.

Definition open_constraint_wrt_co g5 phi5 := open_constraint_wrt_co_rec 0 phi5 g5.

Definition open_constraint_wrt_tm a5 phi5 := open_constraint_wrt_tm_rec 0 phi5 a5.

Definition open_co_wrt_tm a5 g_5 := open_co_wrt_tm_rec 0 g_5 a5.

Definition open_sort_wrt_tm a5 sort5 := open_sort_wrt_tm_rec 0 sort5 a5.

Definition open_tm_wrt_tm a5 a_6 := open_tm_wrt_tm_rec 0 a_6 a5.

(** terms are locally-closed pre-terms *)
(** definitions *)

(* defns LC_co_brs_tm_constraint *)
Inductive lc_co : co -> Prop :=    (* defn lc_co *)
 | lc_g_Triv : 
     (lc_co g_Triv)
 | lc_g_Var_f : forall (c:covar),
     (lc_co (g_Var_f c))
 | lc_g_Beta : forall (a b:tm),
     (lc_tm a) ->
     (lc_tm b) ->
     (lc_co (g_Beta a b))
 | lc_g_Refl : forall (a:tm),
     (lc_tm a) ->
     (lc_co (g_Refl a))
 | lc_g_Refl2 : forall (a b:tm) (g:co),
     (lc_tm a) ->
     (lc_tm b) ->
     (lc_co g) ->
     (lc_co (g_Refl2 a b g))
 | lc_g_Sym : forall (g:co),
     (lc_co g) ->
     (lc_co (g_Sym g))
 | lc_g_Trans : forall (g1 g2:co),
     (lc_co g1) ->
     (lc_co g2) ->
     (lc_co (g_Trans g1 g2))
 | lc_g_PiCong : forall (rho:relflag) (g1 g2:co),
     (lc_co g1) ->
      ( forall x , lc_co  ( open_co_wrt_tm g2 (a_Var_f x) )  )  ->
     (lc_co (g_PiCong rho g1 g2))
 | lc_g_AbsCong : forall (rho:relflag) (g1 g2:co),
     (lc_co g1) ->
      ( forall x , lc_co  ( open_co_wrt_tm g2 (a_Var_f x) )  )  ->
     (lc_co (g_AbsCong rho g1 g2))
 | lc_g_AppCong : forall (g1:co) (rho:relflag) (g2:co),
     (lc_co g1) ->
     (lc_co g2) ->
     (lc_co (g_AppCong g1 rho g2))
 | lc_g_PiFst : forall (g:co),
     (lc_co g) ->
     (lc_co (g_PiFst g))
 | lc_g_CPiFst : forall (g:co),
     (lc_co g) ->
     (lc_co (g_CPiFst g))
 | lc_g_IsoSnd : forall (g:co),
     (lc_co g) ->
     (lc_co (g_IsoSnd g))
 | lc_g_PiSnd : forall (g1 g2:co),
     (lc_co g1) ->
     (lc_co g2) ->
     (lc_co (g_PiSnd g1 g2))
 | lc_g_CPiCong : forall (g1 g3:co),
     (lc_co g1) ->
      ( forall c , lc_co  ( open_co_wrt_co g3 (g_Var_f c) )  )  ->
     (lc_co (g_CPiCong g1 g3))
 | lc_g_CAbsCong : forall (g1 g3 g4:co),
     (lc_co g1) ->
      ( forall c , lc_co  ( open_co_wrt_co g3 (g_Var_f c) )  )  ->
     (lc_co g4) ->
     (lc_co (g_CAbsCong g1 g3 g4))
 | lc_g_CAppCong : forall (g g1 g2:co),
     (lc_co g) ->
     (lc_co g1) ->
     (lc_co g2) ->
     (lc_co (g_CAppCong g g1 g2))
 | lc_g_CPiSnd : forall (g g1 g2:co),
     (lc_co g) ->
     (lc_co g1) ->
     (lc_co g2) ->
     (lc_co (g_CPiSnd g g1 g2))
 | lc_g_Cast : forall (g1 g2:co),
     (lc_co g1) ->
     (lc_co g2) ->
     (lc_co (g_Cast g1 g2))
 | lc_g_EqCong : forall (g1:co) (A:tm) (R:role) (g2:co),
     (lc_co g1) ->
     (lc_tm A) ->
     (lc_co g2) ->
     (lc_co (g_EqCong g1 A R g2))
 | lc_g_IsoConv : forall (phi1 phi2:constraint) (g:co),
     (lc_constraint phi1) ->
     (lc_constraint phi2) ->
     (lc_co g) ->
     (lc_co (g_IsoConv phi1 phi2 g))
 | lc_g_Eta : forall (a:tm),
     (lc_tm a) ->
     (lc_co (g_Eta a))
 | lc_g_Left : forall (g g':co),
     (lc_co g) ->
     (lc_co g') ->
     (lc_co (g_Left g g'))
 | lc_g_Right : forall (g g':co),
     (lc_co g) ->
     (lc_co g') ->
     (lc_co (g_Right g g'))
with lc_brs : brs -> Prop :=    (* defn lc_brs *)
 | lc_br_None : 
     (lc_brs br_None)
 | lc_br_One : forall (K:datacon) (a:tm) (brs5:brs),
     (lc_tm a) ->
     (lc_brs brs5) ->
     (lc_brs (br_One K a brs5))
with lc_tm : tm -> Prop :=    (* defn lc_tm *)
 | lc_a_Star : 
     (lc_tm a_Star)
 | lc_a_Var_f : forall (x:tmvar),
     (lc_tm (a_Var_f x))
 | lc_a_Abs : forall (rho:relflag) (A:tm) (R:role) (b:tm),
     (lc_tm A) ->
      ( forall x , lc_tm  ( open_tm_wrt_tm b (a_Var_f x) )  )  ->
     (lc_tm (a_Abs rho A R b))
 | lc_a_UAbs : forall (rho:relflag) (b:tm),
      ( forall x , lc_tm  ( open_tm_wrt_tm b (a_Var_f x) )  )  ->
     (lc_tm (a_UAbs rho b))
 | lc_a_App : forall (a:tm) (rho:relflag) (b:tm),
     (lc_tm a) ->
     (lc_tm b) ->
     (lc_tm (a_App a rho b))
 | lc_a_Fam : forall (F:tyfam),
     (lc_tm (a_Fam F))
 | lc_a_Const : forall (T:const),
     (lc_tm (a_Const T))
 | lc_a_Pi : forall (rho:relflag) (A:tm) (R:role) (B:tm),
     (lc_tm A) ->
      ( forall x , lc_tm  ( open_tm_wrt_tm B (a_Var_f x) )  )  ->
     (lc_tm (a_Pi rho A R B))
 | lc_a_Conv : forall (a:tm) (g:co),
     (lc_tm a) ->
     (lc_co g) ->
     (lc_tm (a_Conv a g))
 | lc_a_CPi : forall (phi:constraint) (B:tm),
     (lc_constraint phi) ->
      ( forall c , lc_tm  ( open_tm_wrt_co B (g_Var_f c) )  )  ->
     (lc_tm (a_CPi phi B))
 | lc_a_CAbs : forall (phi:constraint) (b:tm),
     (lc_constraint phi) ->
      ( forall c , lc_tm  ( open_tm_wrt_co b (g_Var_f c) )  )  ->
     (lc_tm (a_CAbs phi b))
 | lc_a_UCAbs : forall (b:tm),
      ( forall c , lc_tm  ( open_tm_wrt_co b (g_Var_f c) )  )  ->
     (lc_tm (a_UCAbs b))
 | lc_a_CApp : forall (a:tm) (g:co),
     (lc_tm a) ->
     (lc_co g) ->
     (lc_tm (a_CApp a g))
 | lc_a_Bullet : 
     (lc_tm a_Bullet)
 | lc_a_DataCon : forall (K:datacon),
     (lc_tm (a_DataCon K))
 | lc_a_Case : forall (a:tm) (brs5:brs),
     (lc_tm a) ->
     (lc_brs brs5) ->
     (lc_tm (a_Case a brs5))
with lc_constraint : constraint -> Prop :=    (* defn lc_constraint *)
 | lc_Eq : forall (a b A:tm) (R:role),
     (lc_tm a) ->
     (lc_tm b) ->
     (lc_tm A) ->
     (lc_constraint (Eq a b A R)).

(* defns LC_sort *)
Inductive lc_sort : sort -> Prop :=    (* defn lc_sort *)
 | lc_Tm : forall (A:tm) (R:role),
     (lc_tm A) ->
     (lc_sort (Tm A R))
 | lc_Co : forall (phi:constraint),
     (lc_constraint phi) ->
     (lc_sort (Co phi)).

(* defns LC_sig_sort *)
Inductive lc_sig_sort : sig_sort -> Prop :=    (* defn lc_sig_sort *)
 | lc_Cs : forall (A:tm),
     (lc_tm A) ->
     (lc_sig_sort (Cs A))
 | lc_Ax : forall (a A:tm) (R:role),
     (lc_tm a) ->
     (lc_tm A) ->
     (lc_sig_sort (Ax a A R)).
(** free variables *)
Fixpoint fv_tm_tm_co (g_5:co) : vars :=
  match g_5 with
  | g_Triv => {}
  | (g_Var_b nat) => {}
  | (g_Var_f c) => {}
  | (g_Beta a b) => (fv_tm_tm_tm a) \u (fv_tm_tm_tm b)
  | (g_Refl a) => (fv_tm_tm_tm a)
  | (g_Refl2 a b g) => (fv_tm_tm_tm a) \u (fv_tm_tm_tm b) \u (fv_tm_tm_co g)
  | (g_Sym g) => (fv_tm_tm_co g)
  | (g_Trans g1 g2) => (fv_tm_tm_co g1) \u (fv_tm_tm_co g2)
  | (g_PiCong rho g1 g2) => (fv_tm_tm_co g1) \u (fv_tm_tm_co g2)
  | (g_AbsCong rho g1 g2) => (fv_tm_tm_co g1) \u (fv_tm_tm_co g2)
  | (g_AppCong g1 rho g2) => (fv_tm_tm_co g1) \u (fv_tm_tm_co g2)
  | (g_PiFst g) => (fv_tm_tm_co g)
  | (g_CPiFst g) => (fv_tm_tm_co g)
  | (g_IsoSnd g) => (fv_tm_tm_co g)
  | (g_PiSnd g1 g2) => (fv_tm_tm_co g1) \u (fv_tm_tm_co g2)
  | (g_CPiCong g1 g3) => (fv_tm_tm_co g1) \u (fv_tm_tm_co g3)
  | (g_CAbsCong g1 g3 g4) => (fv_tm_tm_co g1) \u (fv_tm_tm_co g3) \u (fv_tm_tm_co g4)
  | (g_CAppCong g g1 g2) => (fv_tm_tm_co g) \u (fv_tm_tm_co g1) \u (fv_tm_tm_co g2)
  | (g_CPiSnd g g1 g2) => (fv_tm_tm_co g) \u (fv_tm_tm_co g1) \u (fv_tm_tm_co g2)
  | (g_Cast g1 g2) => (fv_tm_tm_co g1) \u (fv_tm_tm_co g2)
  | (g_EqCong g1 A R g2) => (fv_tm_tm_co g1) \u (fv_tm_tm_tm A) \u (fv_tm_tm_co g2)
  | (g_IsoConv phi1 phi2 g) => (fv_tm_tm_constraint phi1) \u (fv_tm_tm_constraint phi2) \u (fv_tm_tm_co g)
  | (g_Eta a) => (fv_tm_tm_tm a)
  | (g_Left g g') => (fv_tm_tm_co g) \u (fv_tm_tm_co g')
  | (g_Right g g') => (fv_tm_tm_co g) \u (fv_tm_tm_co g')
end
with fv_tm_tm_brs (brs_6:brs) : vars :=
  match brs_6 with
  | br_None => {}
  | (br_One K a brs5) => (fv_tm_tm_tm a) \u (fv_tm_tm_brs brs5)
end
with fv_tm_tm_tm (a5:tm) : vars :=
  match a5 with
  | a_Star => {}
  | (a_Var_b nat) => {}
  | (a_Var_f x) => {{x}}
  | (a_Abs rho A R b) => (fv_tm_tm_tm A) \u (fv_tm_tm_tm b)
  | (a_UAbs rho b) => (fv_tm_tm_tm b)
  | (a_App a rho b) => (fv_tm_tm_tm a) \u (fv_tm_tm_tm b)
  | (a_Fam F) => {}
  | (a_Const T) => {}
  | (a_Pi rho A R B) => (fv_tm_tm_tm A) \u (fv_tm_tm_tm B)
  | (a_Conv a g) => (fv_tm_tm_tm a) \u (fv_tm_tm_co g)
  | (a_CPi phi B) => (fv_tm_tm_constraint phi) \u (fv_tm_tm_tm B)
  | (a_CAbs phi b) => (fv_tm_tm_constraint phi) \u (fv_tm_tm_tm b)
  | (a_UCAbs b) => (fv_tm_tm_tm b)
  | (a_CApp a g) => (fv_tm_tm_tm a) \u (fv_tm_tm_co g)
  | a_Bullet => {}
  | (a_DataCon K) => {}
  | (a_Case a brs5) => (fv_tm_tm_tm a) \u (fv_tm_tm_brs brs5)
end
with fv_tm_tm_constraint (phi5:constraint) : vars :=
  match phi5 with
  | (Eq a b A R) => (fv_tm_tm_tm a) \u (fv_tm_tm_tm b) \u (fv_tm_tm_tm A)
end.

Fixpoint fv_co_co_co (g_5:co) : vars :=
  match g_5 with
  | g_Triv => {}
  | (g_Var_b nat) => {}
  | (g_Var_f c) => {{c}}
  | (g_Beta a b) => (fv_co_co_tm a) \u (fv_co_co_tm b)
  | (g_Refl a) => (fv_co_co_tm a)
  | (g_Refl2 a b g) => (fv_co_co_tm a) \u (fv_co_co_tm b) \u (fv_co_co_co g)
  | (g_Sym g) => (fv_co_co_co g)
  | (g_Trans g1 g2) => (fv_co_co_co g1) \u (fv_co_co_co g2)
  | (g_PiCong rho g1 g2) => (fv_co_co_co g1) \u (fv_co_co_co g2)
  | (g_AbsCong rho g1 g2) => (fv_co_co_co g1) \u (fv_co_co_co g2)
  | (g_AppCong g1 rho g2) => (fv_co_co_co g1) \u (fv_co_co_co g2)
  | (g_PiFst g) => (fv_co_co_co g)
  | (g_CPiFst g) => (fv_co_co_co g)
  | (g_IsoSnd g) => (fv_co_co_co g)
  | (g_PiSnd g1 g2) => (fv_co_co_co g1) \u (fv_co_co_co g2)
  | (g_CPiCong g1 g3) => (fv_co_co_co g1) \u (fv_co_co_co g3)
  | (g_CAbsCong g1 g3 g4) => (fv_co_co_co g1) \u (fv_co_co_co g3) \u (fv_co_co_co g4)
  | (g_CAppCong g g1 g2) => (fv_co_co_co g) \u (fv_co_co_co g1) \u (fv_co_co_co g2)
  | (g_CPiSnd g g1 g2) => (fv_co_co_co g) \u (fv_co_co_co g1) \u (fv_co_co_co g2)
  | (g_Cast g1 g2) => (fv_co_co_co g1) \u (fv_co_co_co g2)
  | (g_EqCong g1 A R g2) => (fv_co_co_co g1) \u (fv_co_co_tm A) \u (fv_co_co_co g2)
  | (g_IsoConv phi1 phi2 g) => (fv_co_co_constraint phi1) \u (fv_co_co_constraint phi2) \u (fv_co_co_co g)
  | (g_Eta a) => (fv_co_co_tm a)
  | (g_Left g g') => (fv_co_co_co g) \u (fv_co_co_co g')
  | (g_Right g g') => (fv_co_co_co g) \u (fv_co_co_co g')
end
with fv_co_co_brs (brs_6:brs) : vars :=
  match brs_6 with
  | br_None => {}
  | (br_One K a brs5) => (fv_co_co_tm a) \u (fv_co_co_brs brs5)
end
with fv_co_co_tm (a5:tm) : vars :=
  match a5 with
  | a_Star => {}
  | (a_Var_b nat) => {}
  | (a_Var_f x) => {}
  | (a_Abs rho A R b) => (fv_co_co_tm A) \u (fv_co_co_tm b)
  | (a_UAbs rho b) => (fv_co_co_tm b)
  | (a_App a rho b) => (fv_co_co_tm a) \u (fv_co_co_tm b)
  | (a_Fam F) => {}
  | (a_Const T) => {}
  | (a_Pi rho A R B) => (fv_co_co_tm A) \u (fv_co_co_tm B)
  | (a_Conv a g) => (fv_co_co_tm a) \u (fv_co_co_co g)
  | (a_CPi phi B) => (fv_co_co_constraint phi) \u (fv_co_co_tm B)
  | (a_CAbs phi b) => (fv_co_co_constraint phi) \u (fv_co_co_tm b)
  | (a_UCAbs b) => (fv_co_co_tm b)
  | (a_CApp a g) => (fv_co_co_tm a) \u (fv_co_co_co g)
  | a_Bullet => {}
  | (a_DataCon K) => {}
  | (a_Case a brs5) => (fv_co_co_tm a) \u (fv_co_co_brs brs5)
end
with fv_co_co_constraint (phi5:constraint) : vars :=
  match phi5 with
  | (Eq a b A R) => (fv_co_co_tm a) \u (fv_co_co_tm b) \u (fv_co_co_tm A)
end.

Definition fv_tm_tm_sort (sort5:sort) : vars :=
  match sort5 with
  | (Tm A R) => (fv_tm_tm_tm A)
  | (Co phi) => (fv_tm_tm_constraint phi)
end.

Definition fv_co_co_sort (sort5:sort) : vars :=
  match sort5 with
  | (Tm A R) => (fv_co_co_tm A)
  | (Co phi) => (fv_co_co_constraint phi)
end.

Definition fv_tm_tm_sig_sort (sig_sort5:sig_sort) : vars :=
  match sig_sort5 with
  | (Cs A) => (fv_tm_tm_tm A)
  | (Ax a A R) => (fv_tm_tm_tm a) \u (fv_tm_tm_tm A)
end.

Definition fv_co_co_sig_sort (sig_sort5:sig_sort) : vars :=
  match sig_sort5 with
  | (Cs A) => (fv_co_co_tm A)
  | (Ax a A R) => (fv_co_co_tm a) \u (fv_co_co_tm A)
end.

(** substitutions *)
Fixpoint tm_subst_tm_co (a5:tm) (x5:tmvar) (g_5:co) {struct g_5} : co :=
  match g_5 with
  | g_Triv => g_Triv 
  | (g_Var_b nat) => g_Var_b nat
  | (g_Var_f c) => g_Var_f c
  | (g_Beta a b) => g_Beta (tm_subst_tm_tm a5 x5 a) (tm_subst_tm_tm a5 x5 b)
  | (g_Refl a) => g_Refl (tm_subst_tm_tm a5 x5 a)
  | (g_Refl2 a b g) => g_Refl2 (tm_subst_tm_tm a5 x5 a) (tm_subst_tm_tm a5 x5 b) (tm_subst_tm_co a5 x5 g)
  | (g_Sym g) => g_Sym (tm_subst_tm_co a5 x5 g)
  | (g_Trans g1 g2) => g_Trans (tm_subst_tm_co a5 x5 g1) (tm_subst_tm_co a5 x5 g2)
  | (g_PiCong rho g1 g2) => g_PiCong rho (tm_subst_tm_co a5 x5 g1) (tm_subst_tm_co a5 x5 g2)
  | (g_AbsCong rho g1 g2) => g_AbsCong rho (tm_subst_tm_co a5 x5 g1) (tm_subst_tm_co a5 x5 g2)
  | (g_AppCong g1 rho g2) => g_AppCong (tm_subst_tm_co a5 x5 g1) rho (tm_subst_tm_co a5 x5 g2)
  | (g_PiFst g) => g_PiFst (tm_subst_tm_co a5 x5 g)
  | (g_CPiFst g) => g_CPiFst (tm_subst_tm_co a5 x5 g)
  | (g_IsoSnd g) => g_IsoSnd (tm_subst_tm_co a5 x5 g)
  | (g_PiSnd g1 g2) => g_PiSnd (tm_subst_tm_co a5 x5 g1) (tm_subst_tm_co a5 x5 g2)
  | (g_CPiCong g1 g3) => g_CPiCong (tm_subst_tm_co a5 x5 g1) (tm_subst_tm_co a5 x5 g3)
  | (g_CAbsCong g1 g3 g4) => g_CAbsCong (tm_subst_tm_co a5 x5 g1) (tm_subst_tm_co a5 x5 g3) (tm_subst_tm_co a5 x5 g4)
  | (g_CAppCong g g1 g2) => g_CAppCong (tm_subst_tm_co a5 x5 g) (tm_subst_tm_co a5 x5 g1) (tm_subst_tm_co a5 x5 g2)
  | (g_CPiSnd g g1 g2) => g_CPiSnd (tm_subst_tm_co a5 x5 g) (tm_subst_tm_co a5 x5 g1) (tm_subst_tm_co a5 x5 g2)
  | (g_Cast g1 g2) => g_Cast (tm_subst_tm_co a5 x5 g1) (tm_subst_tm_co a5 x5 g2)
  | (g_EqCong g1 A R g2) => g_EqCong (tm_subst_tm_co a5 x5 g1) (tm_subst_tm_tm a5 x5 A) R (tm_subst_tm_co a5 x5 g2)
  | (g_IsoConv phi1 phi2 g) => g_IsoConv (tm_subst_tm_constraint a5 x5 phi1) (tm_subst_tm_constraint a5 x5 phi2) (tm_subst_tm_co a5 x5 g)
  | (g_Eta a) => g_Eta (tm_subst_tm_tm a5 x5 a)
  | (g_Left g g') => g_Left (tm_subst_tm_co a5 x5 g) (tm_subst_tm_co a5 x5 g')
  | (g_Right g g') => g_Right (tm_subst_tm_co a5 x5 g) (tm_subst_tm_co a5 x5 g')
end
with tm_subst_tm_brs (a5:tm) (x5:tmvar) (brs_6:brs) {struct brs_6} : brs :=
  match brs_6 with
  | br_None => br_None 
  | (br_One K a brs5) => br_One K (tm_subst_tm_tm a5 x5 a) (tm_subst_tm_brs a5 x5 brs5)
end
with tm_subst_tm_tm (a5:tm) (x5:tmvar) (a_6:tm) {struct a_6} : tm :=
  match a_6 with
  | a_Star => a_Star 
  | (a_Var_b nat) => a_Var_b nat
  | (a_Var_f x) => (if eq_var x x5 then a5 else (a_Var_f x))
  | (a_Abs rho A R b) => a_Abs rho (tm_subst_tm_tm a5 x5 A) R (tm_subst_tm_tm a5 x5 b)
  | (a_UAbs rho b) => a_UAbs rho (tm_subst_tm_tm a5 x5 b)
  | (a_App a rho b) => a_App (tm_subst_tm_tm a5 x5 a) rho (tm_subst_tm_tm a5 x5 b)
  | (a_Fam F) => a_Fam F
  | (a_Const T) => a_Const T
  | (a_Pi rho A R B) => a_Pi rho (tm_subst_tm_tm a5 x5 A) R (tm_subst_tm_tm a5 x5 B)
  | (a_Conv a g) => a_Conv (tm_subst_tm_tm a5 x5 a) (tm_subst_tm_co a5 x5 g)
  | (a_CPi phi B) => a_CPi (tm_subst_tm_constraint a5 x5 phi) (tm_subst_tm_tm a5 x5 B)
  | (a_CAbs phi b) => a_CAbs (tm_subst_tm_constraint a5 x5 phi) (tm_subst_tm_tm a5 x5 b)
  | (a_UCAbs b) => a_UCAbs (tm_subst_tm_tm a5 x5 b)
  | (a_CApp a g) => a_CApp (tm_subst_tm_tm a5 x5 a) (tm_subst_tm_co a5 x5 g)
  | a_Bullet => a_Bullet 
  | (a_DataCon K) => a_DataCon K
  | (a_Case a brs5) => a_Case (tm_subst_tm_tm a5 x5 a) (tm_subst_tm_brs a5 x5 brs5)
end
with tm_subst_tm_constraint (a5:tm) (x5:tmvar) (phi5:constraint) {struct phi5} : constraint :=
  match phi5 with
  | (Eq a b A R) => Eq (tm_subst_tm_tm a5 x5 a) (tm_subst_tm_tm a5 x5 b) (tm_subst_tm_tm a5 x5 A) R
end.

Fixpoint co_subst_co_co (g_5:co) (c5:covar) (g__6:co) {struct g__6} : co :=
  match g__6 with
  | g_Triv => g_Triv 
  | (g_Var_b nat) => g_Var_b nat
  | (g_Var_f c) => (if eq_var c c5 then g_5 else (g_Var_f c))
  | (g_Beta a b) => g_Beta (co_subst_co_tm g_5 c5 a) (co_subst_co_tm g_5 c5 b)
  | (g_Refl a) => g_Refl (co_subst_co_tm g_5 c5 a)
  | (g_Refl2 a b g) => g_Refl2 (co_subst_co_tm g_5 c5 a) (co_subst_co_tm g_5 c5 b) (co_subst_co_co g_5 c5 g)
  | (g_Sym g) => g_Sym (co_subst_co_co g_5 c5 g)
  | (g_Trans g1 g2) => g_Trans (co_subst_co_co g_5 c5 g1) (co_subst_co_co g_5 c5 g2)
  | (g_PiCong rho g1 g2) => g_PiCong rho (co_subst_co_co g_5 c5 g1) (co_subst_co_co g_5 c5 g2)
  | (g_AbsCong rho g1 g2) => g_AbsCong rho (co_subst_co_co g_5 c5 g1) (co_subst_co_co g_5 c5 g2)
  | (g_AppCong g1 rho g2) => g_AppCong (co_subst_co_co g_5 c5 g1) rho (co_subst_co_co g_5 c5 g2)
  | (g_PiFst g) => g_PiFst (co_subst_co_co g_5 c5 g)
  | (g_CPiFst g) => g_CPiFst (co_subst_co_co g_5 c5 g)
  | (g_IsoSnd g) => g_IsoSnd (co_subst_co_co g_5 c5 g)
  | (g_PiSnd g1 g2) => g_PiSnd (co_subst_co_co g_5 c5 g1) (co_subst_co_co g_5 c5 g2)
  | (g_CPiCong g1 g3) => g_CPiCong (co_subst_co_co g_5 c5 g1) (co_subst_co_co g_5 c5 g3)
  | (g_CAbsCong g1 g3 g4) => g_CAbsCong (co_subst_co_co g_5 c5 g1) (co_subst_co_co g_5 c5 g3) (co_subst_co_co g_5 c5 g4)
  | (g_CAppCong g g1 g2) => g_CAppCong (co_subst_co_co g_5 c5 g) (co_subst_co_co g_5 c5 g1) (co_subst_co_co g_5 c5 g2)
  | (g_CPiSnd g g1 g2) => g_CPiSnd (co_subst_co_co g_5 c5 g) (co_subst_co_co g_5 c5 g1) (co_subst_co_co g_5 c5 g2)
  | (g_Cast g1 g2) => g_Cast (co_subst_co_co g_5 c5 g1) (co_subst_co_co g_5 c5 g2)
  | (g_EqCong g1 A R g2) => g_EqCong (co_subst_co_co g_5 c5 g1) (co_subst_co_tm g_5 c5 A) R (co_subst_co_co g_5 c5 g2)
  | (g_IsoConv phi1 phi2 g) => g_IsoConv (co_subst_co_constraint g_5 c5 phi1) (co_subst_co_constraint g_5 c5 phi2) (co_subst_co_co g_5 c5 g)
  | (g_Eta a) => g_Eta (co_subst_co_tm g_5 c5 a)
  | (g_Left g g') => g_Left (co_subst_co_co g_5 c5 g) (co_subst_co_co g_5 c5 g')
  | (g_Right g g') => g_Right (co_subst_co_co g_5 c5 g) (co_subst_co_co g_5 c5 g')
end
with co_subst_co_brs (g5:co) (c5:covar) (brs_6:brs) {struct brs_6} : brs :=
  match brs_6 with
  | br_None => br_None 
  | (br_One K a brs5) => br_One K (co_subst_co_tm g5 c5 a) (co_subst_co_brs g5 c5 brs5)
end
with co_subst_co_tm (g5:co) (c5:covar) (a5:tm) {struct a5} : tm :=
  match a5 with
  | a_Star => a_Star 
  | (a_Var_b nat) => a_Var_b nat
  | (a_Var_f x) => a_Var_f x
  | (a_Abs rho A R b) => a_Abs rho (co_subst_co_tm g5 c5 A) R (co_subst_co_tm g5 c5 b)
  | (a_UAbs rho b) => a_UAbs rho (co_subst_co_tm g5 c5 b)
  | (a_App a rho b) => a_App (co_subst_co_tm g5 c5 a) rho (co_subst_co_tm g5 c5 b)
  | (a_Fam F) => a_Fam F
  | (a_Const T) => a_Const T
  | (a_Pi rho A R B) => a_Pi rho (co_subst_co_tm g5 c5 A) R (co_subst_co_tm g5 c5 B)
  | (a_Conv a g) => a_Conv (co_subst_co_tm g5 c5 a) (co_subst_co_co g5 c5 g)
  | (a_CPi phi B) => a_CPi (co_subst_co_constraint g5 c5 phi) (co_subst_co_tm g5 c5 B)
  | (a_CAbs phi b) => a_CAbs (co_subst_co_constraint g5 c5 phi) (co_subst_co_tm g5 c5 b)
  | (a_UCAbs b) => a_UCAbs (co_subst_co_tm g5 c5 b)
  | (a_CApp a g) => a_CApp (co_subst_co_tm g5 c5 a) (co_subst_co_co g5 c5 g)
  | a_Bullet => a_Bullet 
  | (a_DataCon K) => a_DataCon K
  | (a_Case a brs5) => a_Case (co_subst_co_tm g5 c5 a) (co_subst_co_brs g5 c5 brs5)
end
with co_subst_co_constraint (g5:co) (c5:covar) (phi5:constraint) {struct phi5} : constraint :=
  match phi5 with
  | (Eq a b A R) => Eq (co_subst_co_tm g5 c5 a) (co_subst_co_tm g5 c5 b) (co_subst_co_tm g5 c5 A) R
end.

Definition tm_subst_tm_sort (a5:tm) (x5:tmvar) (sort5:sort) : sort :=
  match sort5 with
  | (Tm A R) => Tm (tm_subst_tm_tm a5 x5 A) R
  | (Co phi) => Co (tm_subst_tm_constraint a5 x5 phi)
end.

Definition co_subst_co_sort (g5:co) (c5:covar) (sort5:sort) : sort :=
  match sort5 with
  | (Tm A R) => Tm (co_subst_co_tm g5 c5 A) R
  | (Co phi) => Co (co_subst_co_constraint g5 c5 phi)
end.

Definition tm_subst_tm_sig_sort (a5:tm) (x5:tmvar) (sig_sort5:sig_sort) : sig_sort :=
  match sig_sort5 with
  | (Cs A) => Cs (tm_subst_tm_tm a5 x5 A)
  | (Ax a A R) => Ax (tm_subst_tm_tm a5 x5 a) (tm_subst_tm_tm a5 x5 A) R
end.

Definition co_subst_co_sig_sort (g5:co) (c5:covar) (sig_sort5:sig_sort) : sig_sort :=
  match sig_sort5 with
  | (Cs A) => Cs (co_subst_co_tm g5 c5 A)
  | (Ax a A R) => Ax (co_subst_co_tm g5 c5 a) (co_subst_co_tm g5 c5 A) R
end.

Fixpoint erase_tm (a : tm) : tm :=
   match a with
   | a_Star    => a_Star
   | a_Var_b n => a_Var_b n
   | a_Var_f x => a_Var_f x
   | a_Abs rho A R b => a_UAbs rho (erase_tm b)
   | a_UAbs rho b => a_UAbs rho (erase_tm b)
   | a_App a Rel b => a_App (erase_tm a) Rel (erase_tm b)
   | a_App a Irrel b => a_App (erase_tm a) Irrel a_Bullet
   | a_Const T => a_Const T
   | a_Fam F => a_Fam F
   | a_Pi rho A R B => a_Pi rho (erase_tm A) R (erase_tm B)
   | a_Conv a _ => erase_tm a
   | a_CPi phi B => a_CPi (erase_constraint phi) (erase_tm B)
   | a_CAbs phi b => a_UCAbs (erase_tm b)
   | a_UCAbs b => a_UCAbs (erase_tm b)
   | a_CApp a g => a_CApp (erase_tm a) g_Triv
   | a_DataCon K => a_Star  (* a_DataCon K *)
   | a_Case a brs => a_Star (* a_Case (erase_tm a) (erase_brs brs) *)
   | a_Bullet => a_Bullet
   end
with erase_brs (x : brs) : brs :=
   match x with
   | br_None => br_None
   | br_One k a y => br_One k (erase_tm a) (erase_brs y)
   end
with erase_constraint (phi : constraint) : constraint :=
   match phi with
   | Eq A B A1 R => Eq (erase_tm A) (erase_tm B) (erase_tm A1) R
   end.

Definition erase_sort s :=
 match s with
 | Tm a R => Tm (erase_tm a) R
 | Co p => Co (erase_constraint p)
end.


Definition erase_csort s :=
 match s with
 | Cs a   => Cs (erase_tm a)
 | Ax a A R => Ax (erase_tm a) (erase_tm A) R
end.

Definition erase_context G := map erase_sort G.
Definition erase_sig S := map erase_csort S.

(* -------------- A specific signature with Fix ------------ *)
Definition Fix : atom.
  pick fresh F.
  exact F.
Qed.

Definition FixDef : tm :=
  (a_Abs Irrel a_Star Rep
         (a_Abs Rel (a_Pi Rel (a_Var_b 0) Rep (a_Var_b 1)) Rep
                (a_App (a_Var_b 0) Rel
                       (a_App (a_App (a_Fam Fix) Irrel (a_Var_b 1)) Rel (a_Var_b 0))))).

Definition FixTy : tm :=
  a_Pi Irrel a_Star Rep
       (a_Pi Rel (a_Pi Rel (a_Var_b 0) Rep (a_Var_b 1)) Rep
             (a_Var_b 1)).


Definition an_toplevel : sig := Fix ~ Ax FixDef FixTy Nom.

Definition toplevel : sig := erase_sig an_toplevel.



(** definitions *)

(* defns JSubRole *)
Inductive SubRole : role -> role -> Prop :=    (* defn SubRole *)
 | NomRep : 
     SubRole Nom Rep
 | Refl : forall (R:role),
     SubRole R R
 | Trans : forall (R1 R3 R2:role),
     SubRole R1 R2 ->
     SubRole R2 R3 ->
     SubRole R1 R3.

(* defns JValue *)
Inductive CoercedValue : tm -> Prop :=    (* defn CoercedValue *)
 | CV : forall (a:tm),
     Value a ->
     CoercedValue a
 | CC : forall (a:tm) (g:co),
     lc_co g ->
     Value a ->
     CoercedValue  ( (a_Conv a g) ) 
with Value : tm -> Prop :=    (* defn Value *)
 | Value_Star : 
     Value a_Star
 | Value_Pi : forall (rho:relflag) (A:tm) (R:role) (B:tm),
     lc_tm A ->
     lc_tm (a_Pi rho A R B) ->
     Value (a_Pi rho A R B)
 | Value_CPi : forall (phi:constraint) (B:tm),
     lc_constraint phi ->
     lc_tm (a_CPi phi B) ->
     Value (a_CPi phi B)
 | Value_AbsRel : forall (A:tm) (R:role) (a:tm),
     lc_tm A ->
     lc_tm (a_Abs Rel A R a) ->
     Value (a_Abs Rel A R a)
 | Value_UAbsRel : forall (a:tm),
     lc_tm (a_UAbs Rel a) ->
     Value (a_UAbs Rel a)
 | Value_UAbsIrrel : forall (L:vars) (a:tm),
      ( forall x , x \notin  L  -> Value  ( open_tm_wrt_tm a (a_Var_f x) )  )  ->
     Value (a_UAbs Irrel a)
 | Value_AbsIrrel : forall (L:vars) (A:tm) (R:role) (a:tm),
     lc_tm A ->
      ( forall x , x \notin  L  -> CoercedValue  ( open_tm_wrt_tm a (a_Var_f x) )  )  ->
     Value (a_Abs Irrel A R a)
 | Value_CAbs : forall (phi:constraint) (a:tm),
     lc_constraint phi ->
     lc_tm (a_CAbs phi a) ->
     Value (a_CAbs phi a)
 | Value_UCAbs : forall (a:tm),
     lc_tm (a_UCAbs a) ->
     Value (a_UCAbs a)
with value_type : tm -> Prop :=    (* defn value_type *)
 | value_type_Star : 
     value_type a_Star
 | value_type_Pi : forall (rho:relflag) (A:tm) (R:role) (B:tm),
     lc_tm A ->
     lc_tm (a_Pi rho A R B) ->
     value_type (a_Pi rho A R B)
 | value_type_CPi : forall (phi:constraint) (B:tm),
     lc_constraint phi ->
     lc_tm (a_CPi phi B) ->
     value_type (a_CPi phi B).

(* defns Jconsistent *)
Inductive consistent : tm -> tm -> Prop :=    (* defn consistent *)
 | consistent_a_Star : 
     consistent a_Star a_Star
 | consistent_a_Pi : forall (rho:relflag) (A1:tm) (R:role) (B1 A2 B2:tm),
     lc_tm A1 ->
     lc_tm (a_Pi rho A1 R B1) ->
     lc_tm A2 ->
     lc_tm (a_Pi rho A2 R B2) ->
     consistent  ( (a_Pi rho A1 R B1) )   ( (a_Pi rho A2 R B2) ) 
 | consistent_a_CPi : forall (phi1:constraint) (A1:tm) (phi2:constraint) (A2:tm),
     lc_constraint phi1 ->
     lc_tm (a_CPi phi1 A1) ->
     lc_constraint phi2 ->
     lc_tm (a_CPi phi2 A2) ->
     consistent  ( (a_CPi phi1 A1) )   ( (a_CPi phi2 A2) ) 
 | consistent_a_Step_R : forall (a b:tm),
     lc_tm a ->
      not ( value_type b )  ->
     consistent a b
 | consistent_a_Step_L : forall (a b:tm),
     lc_tm b ->
      not ( value_type a )  ->
     consistent a b.

(* defns Jerased *)
Inductive erased_tm : tm -> Prop :=    (* defn erased_tm *)
 | erased_a_Bullet : 
     erased_tm a_Bullet
 | erased_a_Star : 
     erased_tm a_Star
 | erased_a_Var : forall (x:tmvar),
     erased_tm (a_Var_f x)
 | erased_a_Abs : forall (L:vars) (rho:relflag) (a:tm),
      ( forall x , x \notin  L  -> erased_tm  ( open_tm_wrt_tm a (a_Var_f x) )  )  ->
     erased_tm  ( (a_UAbs rho a) ) 
 | erased_a_App : forall (a:tm) (rho:relflag) (b:tm),
     erased_tm a ->
     erased_tm b ->
     erased_tm  ( (a_App a rho b) ) 
 | erased_a_Pi : forall (L:vars) (rho:relflag) (A:tm) (R:role) (B:tm),
     erased_tm A ->
      ( forall x , x \notin  L  -> erased_tm  ( open_tm_wrt_tm B (a_Var_f x) )  )  ->
     erased_tm  ( (a_Pi rho A R B) ) 
 | erased_a_CPi : forall (L:vars) (a b A:tm) (R:role) (B:tm),
     erased_tm a ->
     erased_tm b ->
     erased_tm A ->
      ( forall c , c \notin  L  -> erased_tm  ( open_tm_wrt_co B (g_Var_f c) )  )  ->
     erased_tm  ( (a_CPi (Eq a b A R) B) ) 
 | erased_a_CAbs : forall (L:vars) (b:tm),
      ( forall c , c \notin  L  -> erased_tm  ( open_tm_wrt_co b (g_Var_f c) )  )  ->
     erased_tm  ( (a_UCAbs b) ) 
 | erased_a_CApp : forall (a:tm),
     erased_tm a ->
     erased_tm  ( (a_CApp a g_Triv) ) 
 | erased_a_Fam : forall (F:tyfam),
     erased_tm (a_Fam F)
 | erased_a_Const : forall (T:const),
     erased_tm (a_Const T).

(* defns JChk *)
Inductive RhoCheck : relflag -> tmvar -> tm -> Prop :=    (* defn RhoCheck *)
 | Rho_Rel : forall (x:tmvar) (A:tm),
      True  ->
     RhoCheck Rel x A
 | Rho_IrrRel : forall (x:tmvar) (A:tm),
      x  \notin fv_tm_tm_tm  A  ->
     RhoCheck Irrel x A.

(* defns Jpar *)
Inductive Par : context -> available_props -> tm -> tm -> Prop :=    (* defn Par *)
 | Par_Refl : forall (G:context) (D:available_props) (a:tm),
     lc_tm a ->
     Par G D a a
 | Par_Beta : forall (G:context) (D:available_props) (a:tm) (rho:relflag) (b a' b':tm),
     Par G D a  ( (a_UAbs rho a') )  ->
     Par G D b b' ->
     Par G D (a_App a rho b)  (open_tm_wrt_tm  a'   b' ) 
 | Par_App : forall (G:context) (D:available_props) (a:tm) (rho:relflag) (b a' b':tm),
     Par G D a a' ->
     Par G D b b' ->
     Par G D (a_App a rho b) (a_App a' rho b')
 | Par_CBeta : forall (G:context) (D:available_props) (a a':tm),
     Par G D a  ( (a_UCAbs a') )  ->
     Par G D (a_CApp a g_Triv)  (open_tm_wrt_co  a'   g_Triv ) 
 | Par_CApp : forall (G:context) (D:available_props) (a a':tm),
     Par G D a a' ->
     Par G D (a_CApp a g_Triv) (a_CApp a' g_Triv)
 | Par_Abs : forall (L:vars) (G:context) (D:available_props) (rho:relflag) (a a':tm),
      ( forall x , x \notin  L  -> Par G D  ( open_tm_wrt_tm a (a_Var_f x) )   ( open_tm_wrt_tm a' (a_Var_f x) )  )  ->
     Par G D (a_UAbs rho a) (a_UAbs rho a')
 | Par_Pi : forall (L:vars) (G:context) (D:available_props) (rho:relflag) (A:tm) (R:role) (B A' B':tm),
     Par G D A A' ->
      ( forall x , x \notin  L  -> Par G D  ( open_tm_wrt_tm B (a_Var_f x) )   ( open_tm_wrt_tm B' (a_Var_f x) )  )  ->
     Par G D (a_Pi rho A R B) (a_Pi rho A' R B')
 | Par_CAbs : forall (L:vars) (G:context) (D:available_props) (a a':tm),
      ( forall c , c \notin  L  -> Par G D  ( open_tm_wrt_co a (g_Var_f c) )   ( open_tm_wrt_co a' (g_Var_f c) )  )  ->
     Par G D (a_UCAbs a) (a_UCAbs a')
 | Par_CPi : forall (L:vars) (G:context) (D:available_props) (A B A1:tm) (R:role) (a A' B' A1' a':tm),
     Par G D A A' ->
     Par G D B B' ->
      ( forall c , c \notin  L  -> Par G D  ( open_tm_wrt_co a (g_Var_f c) )   ( open_tm_wrt_co a' (g_Var_f c) )  )  ->
     Par G D A1 A1' ->
     Par G D (a_CPi (Eq A B A1 R) a) (a_CPi (Eq A' B' A1' R) a')
 | Par_Axiom : forall (G:context) (D:available_props) (F:tyfam) (a A:tm) (R:role),
      binds  F  (Ax  a A R )   toplevel   ->
     Par G D (a_Fam F) a
with MultiPar : context -> available_props -> tm -> tm -> Prop :=    (* defn MultiPar *)
 | MP_Refl : forall (G:context) (D:available_props) (a:tm),
     lc_tm a ->
     MultiPar G D a a
 | MP_Step : forall (G:context) (D:available_props) (a a' b:tm),
     Par G D a b ->
     MultiPar G D b a' ->
     MultiPar G D a a'
with joins : context -> available_props -> tm -> tm -> Prop :=    (* defn joins *)
 | join : forall (G:context) (D:available_props) (a1 a2 b:tm),
     MultiPar G D a1 b ->
     MultiPar G D a2 b ->
     joins G D a1 a2.

(* defns Jbeta *)
Inductive Beta : tm -> tm -> Prop :=    (* defn Beta *)
 | Beta_AppAbs : forall (rho:relflag) (v b:tm),
     lc_tm b ->
     Value  ( (a_UAbs rho v) )  ->
     Beta (a_App  ( (a_UAbs rho v) )  rho b)  (open_tm_wrt_tm  v   b ) 
 | Beta_CAppCAbs : forall (a':tm),
     lc_tm (a_UCAbs a') ->
     Beta (a_CApp  ( (a_UCAbs a') )  g_Triv)  (open_tm_wrt_co  a'   g_Triv ) 
 | Beta_Axiom : forall (F:tyfam) (a A:tm) (R:role),
      binds  F  (Ax  a A R )   toplevel   ->
     Beta (a_Fam F) a
with reduction_in_one : tm -> tm -> Prop :=    (* defn reduction_in_one *)
 | E_AbsTerm : forall (L:vars) (a a':tm),
      ( forall x , x \notin  L  -> reduction_in_one  ( open_tm_wrt_tm a (a_Var_f x) )   ( open_tm_wrt_tm a' (a_Var_f x) )  )  ->
     reduction_in_one (a_UAbs Irrel a) (a_UAbs Irrel a')
 | E_AppLeft : forall (a:tm) (rho:relflag) (b a':tm),
     lc_tm b ->
     reduction_in_one a a' ->
     reduction_in_one (a_App a rho b) (a_App a' rho b)
 | E_CAppLeft : forall (a a':tm),
     reduction_in_one a a' ->
     reduction_in_one (a_CApp a g_Triv) (a_CApp a' g_Triv)
 | E_AppAbs : forall (rho:relflag) (v a:tm),
     lc_tm a ->
     Value  ( (a_UAbs rho v) )  ->
     reduction_in_one (a_App  ( (a_UAbs rho v) )  rho a)  (open_tm_wrt_tm  v   a ) 
 | E_CAppCAbs : forall (b:tm),
     lc_tm (a_UCAbs b) ->
     reduction_in_one (a_CApp  ( (a_UCAbs b) )  g_Triv)  (open_tm_wrt_co  b   g_Triv ) 
 | E_Axiom : forall (F:tyfam) (a A:tm) (R:role),
      binds  F  (Ax  a A R )   toplevel   ->
     reduction_in_one (a_Fam F) a
with reduction : tm -> tm -> Prop :=    (* defn reduction *)
 | Equal : forall (a:tm),
     lc_tm a ->
     reduction a a
 | Step : forall (a a' b:tm),
     reduction_in_one a b ->
     reduction b a' ->
     reduction a a'.

(* defns Jett *)
Inductive PropWff : context -> constraint -> Prop :=    (* defn PropWff *)
 | E_Wff : forall (G:context) (a b A:tm) (R:role),
     Typing G a A R ->
     Typing G b A R ->
      ( Typing G A a_Star R )  ->
     PropWff G (Eq a b A R)
with Typing : context -> tm -> tm -> role -> Prop :=    (* defn Typing *)
 | E_SubRole : forall (G:context) (a A:tm) (R2 R1:role),
     SubRole R1 R2 ->
     Typing G a A R1 ->
     Typing G a A R2
 | E_Star : forall (G:context) (R:role),
     Ctx G ->
     Typing G a_Star a_Star R
 | E_Var : forall (G:context) (x:tmvar) (A:tm) (R:role),
     Ctx G ->
      binds  x  (Tm  A R )  G  ->
     Typing G (a_Var_f x) A R
 | E_Pi : forall (L:vars) (G:context) (rho:relflag) (A:tm) (R:role) (B:tm),
      ( forall x , x \notin  L  -> Typing  (( x ~ Tm  A R ) ++  G )   ( open_tm_wrt_tm B (a_Var_f x) )  a_Star R )  ->
      ( Typing G A a_Star R )  ->
     Typing G (a_Pi rho A R B) a_Star R
 | E_Abs : forall (L:vars) (G:context) (rho:relflag) (a A:tm) (R:role) (B:tm) (R':role),
      ( forall x , x \notin  L  -> Typing  (( x ~ Tm  A R ) ++  G )   ( open_tm_wrt_tm a (a_Var_f x) )   ( open_tm_wrt_tm B (a_Var_f x) )  R' )  ->
      ( Typing G A a_Star R )  ->
      ( forall x , x \notin  L  -> RhoCheck rho x  ( open_tm_wrt_tm a (a_Var_f x) )  )  ->
     SubRole R R' ->
     Typing G (a_UAbs rho a)  ( (a_Pi rho A R B) )  R'
 | E_App : forall (G:context) (b a B:tm) (R':role) (A:tm) (R:role),
     Typing G b (a_Pi Rel A R B) R' ->
     Typing G a A R ->
     Typing G (a_App b Rel a)  (open_tm_wrt_tm  B   a )  R'
 | E_IApp : forall (G:context) (b B a:tm) (R':role) (A:tm) (R:role),
     Typing G b (a_Pi Irrel A R B) R' ->
     Typing G a A R ->
     Typing G (a_App b Irrel a_Bullet)  (open_tm_wrt_tm  B   a )  R'
 | E_Conv : forall (G:context) (a B:tm) (R:role) (A:tm),
     Typing G a A R ->
     DefEq G  (dom  G )  A B a_Star R ->
      ( Typing G B a_Star R )  ->
     Typing G a B R
 | E_CPi : forall (L:vars) (G:context) (phi:constraint) (B:tm) (R:role),
      ( forall c , c \notin  L  -> Typing  (( c ~ Co  phi ) ++  G )   ( open_tm_wrt_co B (g_Var_f c) )  a_Star R )  ->
      ( PropWff G phi )  ->
     Typing G (a_CPi phi B) a_Star R
 | E_CAbs : forall (L:vars) (G:context) (a:tm) (phi:constraint) (B:tm) (R:role),
      ( forall c , c \notin  L  -> Typing  (( c ~ Co  phi ) ++  G )   ( open_tm_wrt_co a (g_Var_f c) )   ( open_tm_wrt_co B (g_Var_f c) )  R )  ->
      ( PropWff G phi )  ->
     Typing G (a_UCAbs a) (a_CPi phi B) R
 | E_CApp : forall (G:context) (a1 B1:tm) (R':role) (a b A:tm) (R:role),
     Typing G a1 (a_CPi  ( (Eq a b A R) )  B1) R' ->
     DefEq G  (dom  G )  a b A R ->
     Typing G (a_CApp a1 g_Triv)  (open_tm_wrt_co  B1   g_Triv )  R'
 | E_Fam : forall (G:context) (F:tyfam) (A:tm) (R:role) (a:tm),
     Ctx G ->
      binds  F  (Ax  a A R )   toplevel   ->
      ( Typing  nil  A a_Star R )  ->
     Typing G (a_Fam F) A R
with Iso : context -> available_props -> constraint -> constraint -> Prop :=    (* defn Iso *)
 | E_PropCong : forall (G:context) (D:available_props) (A1 B1 A:tm) (R:role) (A2 B2:tm),
     DefEq G D A1 A2 A R ->
     DefEq G D B1 B2 A R ->
     Iso G D (Eq A1 B1 A R) (Eq A2 B2 A R)
 | E_IsoConv : forall (G:context) (D:available_props) (A1 A2 A:tm) (R:role) (B:tm),
     DefEq G D A B a_Star R ->
     PropWff G (Eq A1 A2 A R) ->
     PropWff G (Eq A1 A2 B R) ->
     Iso G D (Eq A1 A2 A R) (Eq A1 A2 B R)
 | E_CPiFst : forall (G:context) (D:available_props) (phi1 phi2:constraint) (B1 B2:tm) (R:role),
     DefEq G D (a_CPi phi1 B1) (a_CPi phi2 B2) a_Star R ->
     Iso G D phi1 phi2
with DefEq : context -> available_props -> tm -> tm -> tm -> role -> Prop :=    (* defn DefEq *)
 | E_Assn : forall (G:context) (D:available_props) (a b A:tm) (R:role) (c:covar),
     Ctx G ->
      binds  c  (Co   ( (Eq a b A R) )  )  G  ->
      AtomSetImpl.In  c   D  ->
     DefEq G D a b A R
 | E_Refl : forall (G:context) (D:available_props) (a A:tm) (R:role),
     Typing G a A R ->
     DefEq G D a a A R
 | E_Sym : forall (G:context) (D:available_props) (a b A:tm) (R:role),
     DefEq G D b a A R ->
     DefEq G D a b A R
 | E_Trans : forall (G:context) (D:available_props) (a b A:tm) (R:role) (a1:tm),
     DefEq G D a a1 A R ->
     DefEq G D a1 b A R ->
     DefEq G D a b A R
 | E_Sub : forall (G:context) (D:available_props) (a b A:tm) (R2 R1:role),
     DefEq G D a b A R1 ->
     SubRole R1 R2 ->
     DefEq G D a b A R2
 | E_Beta : forall (G:context) (D:available_props) (a1 a2 B:tm) (R:role),
     Typing G a1 B R ->
      ( Typing G a2 B R )  ->
     Beta a1 a2 ->
     DefEq G D a1 a2 B R
 | E_PiCong : forall (L:vars) (G:context) (D:available_props) (rho:relflag) (A1:tm) (R:role) (B1 A2 B2:tm),
     DefEq G D A1 A2 a_Star R ->
      ( forall x , x \notin  L  -> DefEq  (( x ~ Tm  A1 R ) ++  G )  D  ( open_tm_wrt_tm B1 (a_Var_f x) )   ( open_tm_wrt_tm B2 (a_Var_f x) )  a_Star R )  ->
      ( Typing G A1 a_Star R )  ->
      ( Typing G (a_Pi rho A1 R B1) a_Star R )  ->
      ( Typing G (a_Pi rho A2 R B2) a_Star R )  ->
     DefEq G D  ( (a_Pi rho A1 R B1) )   ( (a_Pi rho A2 R B2) )  a_Star R
 | E_AbsCong : forall (L:vars) (G:context) (D:available_props) (rho:relflag) (b1 b2 A1:tm) (R:role) (B:tm) (R':role),
      ( forall x , x \notin  L  -> DefEq  (( x ~ Tm  A1 R ) ++  G )  D  ( open_tm_wrt_tm b1 (a_Var_f x) )   ( open_tm_wrt_tm b2 (a_Var_f x) )   ( open_tm_wrt_tm B (a_Var_f x) )  R' )  ->
      ( Typing G A1 a_Star R )  ->
      ( SubRole R R' )  ->
      ( forall x , x \notin  L  -> RhoCheck rho x  ( open_tm_wrt_tm b1 (a_Var_f x) )  )  ->
      ( forall x , x \notin  L  -> RhoCheck rho x  ( open_tm_wrt_tm b2 (a_Var_f x) )  )  ->
     DefEq G D  ( (a_UAbs rho b1) )   ( (a_UAbs rho b2) )   ( (a_Pi rho A1 R B) )  R'
 | E_AppCong : forall (G:context) (D:available_props) (a1 a2 b1 b2 B:tm) (R':role) (A:tm) (R:role),
     DefEq G D a1 b1  ( (a_Pi Rel A R B) )  R' ->
     DefEq G D a2 b2 A R ->
     DefEq G D (a_App a1 Rel a2) (a_App b1 Rel b2)  (  (open_tm_wrt_tm  B   a2 )  )  R'
 | E_IAppCong : forall (G:context) (D:available_props) (a1 b1 B a:tm) (R':role) (A:tm) (R:role),
     DefEq G D a1 b1  ( (a_Pi Irrel A R B) )  R' ->
     Typing G a A R ->
     DefEq G D (a_App a1 Irrel a_Bullet) (a_App b1 Irrel a_Bullet)  (  (open_tm_wrt_tm  B   a )  )  R'
 | E_PiFst : forall (G:context) (D:available_props) (A1 A2:tm) (R3:role) (rho:relflag) (R1:role) (B1:tm) (R2:role) (B2:tm) (R':role),
     DefEq G D (a_Pi rho A1 R1 B1) (a_Pi rho A2 R2 B2) a_Star R' ->
     SubRole R3 R1 ->
     SubRole R3 R2 ->
     DefEq G D A1 A2 a_Star R3
 | E_PiSnd : forall (G:context) (D:available_props) (B1 a1 B2 a2:tm) (R':role) (rho:relflag) (A1:tm) (R1:role) (A2:tm) (R2 R:role),
     DefEq G D (a_Pi rho A1 R1 B1) (a_Pi rho A2 R2 B2) a_Star R' ->
     DefEq G D a1 a2 A1 R ->
     SubRole R R1 ->
     SubRole R R2 ->
     DefEq G D  (open_tm_wrt_tm  B1   a1 )   (open_tm_wrt_tm  B2   a2 )  a_Star R'
 | E_CPiCong : forall (L:vars) (G:context) (D:available_props) (phi1:constraint) (A:tm) (phi2:constraint) (B:tm) (R:role),
     Iso G D phi1 phi2 ->
      ( forall c , c \notin  L  -> DefEq  (( c ~ Co  phi1 ) ++  G )  D  ( open_tm_wrt_co A (g_Var_f c) )   ( open_tm_wrt_co B (g_Var_f c) )  a_Star R )  ->
      ( PropWff G phi1 )  ->
      ( Typing G (a_CPi phi1 A) a_Star R )  ->
      ( Typing G (a_CPi phi2 B) a_Star R )  ->
     DefEq G D (a_CPi phi1 A) (a_CPi phi2 B) a_Star R
 | E_CAbsCong : forall (L:vars) (G:context) (D:available_props) (a b:tm) (phi1:constraint) (B:tm) (R:role),
      ( forall c , c \notin  L  -> DefEq  (( c ~ Co  phi1 ) ++  G )  D  ( open_tm_wrt_co a (g_Var_f c) )   ( open_tm_wrt_co b (g_Var_f c) )   ( open_tm_wrt_co B (g_Var_f c) )  R )  ->
      ( PropWff G phi1 )  ->
     DefEq G D  ( (a_UCAbs a) )   ( (a_UCAbs b) )  (a_CPi phi1 B) R
 | E_CAppCong : forall (G:context) (D:available_props) (a1 b1 B:tm) (R':role) (a b A:tm) (R:role),
     DefEq G D a1 b1  ( (a_CPi  ( (Eq a b A R) )  B) )  R' ->
     DefEq G  (dom  G )  a b A R ->
     DefEq G D (a_CApp a1 g_Triv) (a_CApp b1 g_Triv)  (  (open_tm_wrt_co  B   g_Triv )  )  R'
 | E_CPiSnd : forall (G:context) (D:available_props) (B1 B2:tm) (R0:role) (a1 a2 A:tm) (R:role) (a1' a2' A':tm) (R':role),
     DefEq G D (a_CPi  ( (Eq a1 a2 A R) )  B1) (a_CPi  ( (Eq a1' a2' A' R') )  B2) a_Star R0 ->
     DefEq G  (dom  G )  a1 a2 A R ->
     DefEq G  (dom  G )  a1' a2' A' R' ->
     DefEq G D  (open_tm_wrt_co  B1   g_Triv )   (open_tm_wrt_co  B2   g_Triv )  a_Star R0
 | E_Cast : forall (G:context) (D:available_props) (a' b' A':tm) (R':role) (a b A:tm) (R:role),
     DefEq G D a b A R ->
     Iso G D (Eq a b A R) (Eq a' b' A' R') ->
     DefEq G D a' b' A' R'
 | E_EqConv : forall (G:context) (D:available_props) (a b B:tm) (R2:role) (A:tm) (R1:role),
     DefEq G D a b A R1 ->
     DefEq G  (dom  G )  A B a_Star R2 ->
      ( SubRole R1 R2 )  ->
     DefEq G D a b B R2
 | E_IsoSnd : forall (G:context) (D:available_props) (A A':tm) (R0:role) (a b:tm) (R:role) (a' b':tm) (R':role),
     Iso G D (Eq a b A R) (Eq a' b' A' R') ->
     SubRole R R0 ->
     SubRole R' R0 ->
     DefEq G D A A' a_Star R0
with Ctx : context -> Prop :=    (* defn Ctx *)
 | E_Empty : 
     Ctx  nil 
 | E_ConsTm : forall (G:context) (x:tmvar) (A:tm) (R:role),
     Ctx G ->
     Typing G A a_Star R ->
      ~ AtomSetImpl.In  x  (dom  G )  ->
     Ctx  (( x ~ Tm  A R ) ++  G ) 
 | E_ConsCo : forall (G:context) (c:covar) (phi:constraint),
     Ctx G ->
     PropWff G phi ->
      ~ AtomSetImpl.In  c  (dom  G )  ->
     Ctx  (( c ~ Co  phi ) ++  G ) .

(* defns Jsig *)
Inductive Sig : sig -> Prop :=    (* defn Sig *)
 | Sig_Empty : 
     Sig  nil 
 | Sig_ConsAx : forall (S:sig) (F:tyfam) (a A:tm) (R' R:role),
     Sig S ->
     Typing  nil  A a_Star R ->
     Typing  nil  a A R' ->
      ~ AtomSetImpl.In  F  (dom  S )  ->
      ( SubRole R' R )  ->
     Sig  (( F ~ Ax a A R' )++ S ) .

(* defns Jann *)
Inductive AnnPropWff : context -> constraint -> Prop :=    (* defn AnnPropWff *)
 | An_Wff : forall (G:context) (a b A:tm) (R:role) (B:tm),
     AnnTyping G a A R ->
     AnnTyping G b B R ->
      (  (erase_tm  A )   =   (erase_tm  B )  )  ->
     AnnPropWff G (Eq a b A R)
with AnnTyping : context -> tm -> tm -> role -> Prop :=    (* defn AnnTyping *)
 | An_Star : forall (G:context) (R:role),
     AnnCtx G ->
     AnnTyping G a_Star a_Star R
 | An_Var : forall (G:context) (x:tmvar) (A:tm) (R:role),
     AnnCtx G ->
      binds  x  (Tm  A R )  G  ->
     AnnTyping G (a_Var_f x) A R
 | An_Pi : forall (L:vars) (G:context) (rho:relflag) (A:tm) (R:role) (B:tm) (R':role),
      ( forall x , x \notin  L  -> AnnTyping  (( x ~ Tm  A R ) ++  G )   ( open_tm_wrt_tm B (a_Var_f x) )  a_Star R' )  ->
      ( AnnTyping G A a_Star R )  ->
     AnnTyping G (a_Pi rho A R B) a_Star R'
 | An_Abs : forall (L:vars) (G:context) (rho:relflag) (A:tm) (R:role) (a B:tm) (R':role),
      ( AnnTyping G A a_Star R )  ->
      ( forall x , x \notin  L  -> AnnTyping  (( x ~ Tm  A R ) ++  G )   ( open_tm_wrt_tm a (a_Var_f x) )   ( open_tm_wrt_tm B (a_Var_f x) )  R' )  ->
      ( forall x , x \notin  L  -> RhoCheck rho x  (erase_tm   ( open_tm_wrt_tm a (a_Var_f x) )  )  )  ->
     SubRole R R' ->
     AnnTyping G (a_Abs rho A R a)  ( (a_Pi rho A R B) )  R'
 | An_App : forall (G:context) (b:tm) (rho:relflag) (a B:tm) (R':role) (A:tm) (R:role),
     AnnTyping G b  ( (a_Pi rho A R B) )  R' ->
     AnnTyping G a A R ->
     AnnTyping G (a_App b rho a)  (  (open_tm_wrt_tm  B   a )  )  R'
 | An_Conv : forall (G:context) (a:tm) (g:co) (B:tm) (R:role) (A:tm),
     AnnTyping G a A R ->
     AnnDefEq G  (dom  G )  g A B R ->
     AnnTyping G B a_Star R ->
     AnnTyping G (a_Conv a g) B R
 | An_CPi : forall (L:vars) (G:context) (phi:constraint) (B:tm) (R:role),
      ( AnnPropWff G phi )  ->
      ( forall c , c \notin  L  -> AnnTyping  (( c ~ Co  phi ) ++  G )   ( open_tm_wrt_co B (g_Var_f c) )  a_Star R )  ->
     AnnTyping G (a_CPi phi B) a_Star R
 | An_CAbs : forall (L:vars) (G:context) (phi:constraint) (a B:tm) (R:role),
      ( AnnPropWff G phi )  ->
      ( forall c , c \notin  L  -> AnnTyping  (( c ~ Co  phi ) ++  G )   ( open_tm_wrt_co a (g_Var_f c) )   ( open_tm_wrt_co B (g_Var_f c) )  R )  ->
     AnnTyping G (a_CAbs phi a)  ( (a_CPi phi B) )  R
 | An_CApp : forall (G:context) (a1:tm) (g:co) (B:tm) (R':role) (a b A1:tm) (R:role),
     AnnTyping G a1  ( (a_CPi (Eq a b A1 R) B) )  R' ->
     AnnDefEq G  (dom  G )  g a b R ->
     AnnTyping G (a_CApp a1 g)  (open_tm_wrt_co  B   g )  R'
 | An_Fam : forall (G:context) (F:tyfam) (A:tm) (R:role) (a:tm),
     AnnCtx G ->
      binds  F  (Ax  a A R )   an_toplevel   ->
      ( AnnTyping  nil  A a_Star R )  ->
     AnnTyping G (a_Fam F) A R
with AnnIso : context -> available_props -> co -> constraint -> constraint -> Prop :=    (* defn AnnIso *)
 | An_PropCong : forall (G:context) (D:available_props) (g1:co) (A:tm) (R:role) (g2:co) (A1 B1 A2 B2:tm),
     AnnDefEq G D g1 A1 A2 R ->
     AnnDefEq G D g2 B1 B2 R ->
     AnnPropWff G (Eq A1 B1 A R) ->
     AnnPropWff G (Eq A2 B2 A R) ->
     AnnIso G D  ( (g_EqCong g1 A R g2) )   ( (Eq A1 B1 A R) )   ( (Eq A2 B2 A R) ) 
 | An_CPiFst : forall (G:context) (D:available_props) (g:co) (phi1 phi2:constraint) (A2 B2:tm) (R:role),
     AnnDefEq G D g (a_CPi phi1 A2) (a_CPi phi2 B2) R ->
     AnnIso G D (g_CPiFst g) phi1 phi2
 | An_IsoSym : forall (G:context) (D:available_props) (g:co) (phi2 phi1:constraint),
     AnnIso G D g phi1 phi2 ->
     AnnIso G D (g_Sym g) phi2 phi1
 | An_IsoConv : forall (G:context) (D:available_props) (a1 a2 A:tm) (R:role) (a1' a2' B:tm) (g:co),
     AnnDefEq G D g A B R ->
     AnnPropWff G (Eq a1 a2 A R) ->
     AnnPropWff G (Eq a1' a2' B R) ->
      (  (erase_tm  a1 )   =   (erase_tm  a1' )  )  ->
      (  (erase_tm  a2 )   =   (erase_tm  a2' )  )  ->
     AnnIso G D (g_IsoConv  ( (Eq a1 a2 A R) )   ( (Eq a1' a2' B R) )  g)  ( (Eq a1 a2 A R) )   ( (Eq a1' a2' B R) ) 
with AnnDefEq : context -> available_props -> co -> tm -> tm -> role -> Prop :=    (* defn AnnDefEq *)
 | An_Assn : forall (G:context) (D:available_props) (c:covar) (a b:tm) (R:role) (A:tm),
     AnnCtx G ->
      binds  c  (Co  (Eq a b A R) )  G  ->
      AtomSetImpl.In  c   D  ->
     AnnDefEq G D (g_Var_f c) a b R
 | An_Refl : forall (G:context) (D:available_props) (a:tm) (R:role) (A:tm),
     AnnTyping G a A R ->
     AnnDefEq G D (g_Refl a) a a R
 | An_EraseEq : forall (G:context) (D:available_props) (a b:tm) (g:co) (R:role) (A B:tm),
     AnnTyping G a A R ->
     AnnTyping G b B R ->
      (  (erase_tm  a )   =   (erase_tm  b )  )  ->
     AnnDefEq G  (dom  G )  g A B R ->
     AnnDefEq G D (g_Refl2 a b g) a b R
 | An_Sym : forall (G:context) (D:available_props) (g:co) (a b:tm) (R:role) (B A:tm) (g1:co),
     AnnTyping G b B R ->
     AnnTyping G a A R ->
      ( AnnDefEq G  (dom  G )  g1 B A R )  ->
     AnnDefEq G D g b a R ->
     AnnDefEq G D (g_Sym g) a b R
 | An_Trans : forall (G:context) (D:available_props) (g1 g2:co) (a b:tm) (R:role) (a1 A A1:tm) (g3:co),
     AnnDefEq G D g1 a a1 R ->
     AnnDefEq G D g2 a1 b R ->
      ( AnnTyping G a A R )  ->
      ( AnnTyping G a1 A1 R )  ->
      ( AnnDefEq G  (dom  G )  g3 A A1 R )  ->
     AnnDefEq G D  ( (g_Trans g1 g2) )  a b R
 | An_Beta : forall (G:context) (D:available_props) (a1 a2:tm) (R:role) (B0 B1:tm),
     AnnTyping G a1 B0 R ->
     AnnTyping G a2 B1 R ->
      (  (erase_tm  B0 )   =   (erase_tm  B1 )  )  ->
     Beta  (erase_tm  a1 )   (erase_tm  a2 )  ->
     AnnDefEq G D (g_Beta a1 a2) a1 a2 R
 | An_PiCong : forall (L:vars) (G:context) (D:available_props) (rho:relflag) (g1 g2:co) (A1:tm) (R:role) (B1 A2 B3 B2:tm),
     AnnDefEq G D g1 A1 A2 R ->
      ( forall x , x \notin  L  -> AnnDefEq  (( x ~ Tm  A1 R ) ++  G )  D  ( open_co_wrt_tm g2 (a_Var_f x) )   ( open_tm_wrt_tm B1 (a_Var_f x) )    (open_tm_wrt_tm  B2   (a_Var_f x) )   R )  ->
      ( forall x , x \notin  L  ->  (  ( open_tm_wrt_tm B3 (a_Var_f x) )   =   (open_tm_wrt_tm  B2   (a_Conv (a_Var_f x) (g_Sym g1)) )  )  )  ->
     AnnTyping G (a_Pi rho A1 R B1) a_Star R ->
     AnnTyping G (a_Pi rho A1 R B2) a_Star R ->
     AnnTyping G (a_Pi rho A2 R B3) a_Star R ->
     AnnDefEq G D (g_PiCong rho g1 g2)  ( (a_Pi rho A1 R B1) )   ( (a_Pi rho A2 R B3) )  R
 | An_AbsCong : forall (L:vars) (G:context) (D:available_props) (rho:relflag) (g1 g2:co) (A1:tm) (R:role) (b1 A2 b3:tm) (R':role) (b2 B:tm),
     AnnDefEq G D g1 A1 A2 R ->
      ( forall x , x \notin  L  -> AnnDefEq  (( x ~ Tm  A1 R ) ++  G )  D  ( open_co_wrt_tm g2 (a_Var_f x) )   ( open_tm_wrt_tm b1 (a_Var_f x) )    (open_tm_wrt_tm  b2   (a_Var_f x) )   R' )  ->
      ( forall x , x \notin  L  ->  (  ( open_tm_wrt_tm b3 (a_Var_f x) )   =   (open_tm_wrt_tm  b2   (a_Conv (a_Var_f x) (g_Sym g1)) )  )  )  ->
      ( AnnTyping G A1 a_Star R )  ->
     AnnTyping G A2 a_Star R ->
      ( forall x , x \notin  L  -> RhoCheck rho x  (erase_tm   ( open_tm_wrt_tm b1 (a_Var_f x) )  )  )  ->
      ( forall x , x \notin  L  -> RhoCheck rho x  (erase_tm   ( open_tm_wrt_tm b3 (a_Var_f x) )  )  )  ->
      ( AnnTyping G  ( (a_Abs rho A1 R b2) )  B R' )  ->
      ( SubRole R R' )  ->
     AnnDefEq G D  ( (g_AbsCong rho g1 g2) )   ( (a_Abs rho A1 R b1) )   ( (a_Abs rho A2 R b3) )  R'
 | An_AppCong : forall (G:context) (D:available_props) (g1:co) (rho:relflag) (g2:co) (a1 a2 b1 b2:tm) (R' R:role) (A B:tm) (g3:co),
     AnnDefEq G D g1 a1 b1 R' ->
     AnnDefEq G D g2 a2 b2 R ->
     AnnTyping G (a_App a1 rho a2) A R' ->
     AnnTyping G (a_App b1 rho b2) B R' ->
      ( AnnDefEq G  (dom  G )  g3 A B R' )  ->
      ( SubRole R R' )  ->
     AnnDefEq G D (g_AppCong g1 rho g2) (a_App a1 rho a2) (a_App b1 rho b2) R'
 | An_PiFst : forall (G:context) (D:available_props) (g:co) (A1 A2:tm) (R3:role) (rho:relflag) (R1:role) (B1:tm) (R2:role) (B2:tm) (R:role),
     AnnDefEq G D g (a_Pi rho A1 R1 B1) (a_Pi rho A2 R2 B2) R ->
     SubRole R3 R1 ->
     SubRole R3 R2 ->
     AnnDefEq G D (g_PiFst g) A1 A2 R3
 | An_PiSnd : forall (G:context) (D:available_props) (g1 g2:co) (B1 a1 B2 a2:tm) (R':role) (rho:relflag) (A1:tm) (R1:role) (A2:tm) (R2 R:role),
     AnnDefEq G D g1 (a_Pi rho A1 R1 B1) (a_Pi rho A2 R2 B2) R' ->
     AnnDefEq G D g2 a1 a2 R ->
     AnnTyping G a1 A1 R ->
     AnnTyping G a2 A2 R ->
     SubRole R R1 ->
     SubRole R R2 ->
     AnnDefEq G D (g_PiSnd g1 g2)   (open_tm_wrt_tm  B1   a1 )     (open_tm_wrt_tm  B2   a2 )   R'
 | An_CPiCong : forall (L:vars) (G:context) (D:available_props) (g1 g3:co) (phi1:constraint) (B1:tm) (phi2:constraint) (B3:tm) (R:role) (B2:tm),
     AnnIso G D g1 phi1 phi2 ->
      ( forall c , c \notin  L  -> AnnDefEq  (( c ~ Co  phi1 ) ++  G )  D  ( open_co_wrt_co g3 (g_Var_f c) )   ( open_tm_wrt_co B1 (g_Var_f c) )    (open_tm_wrt_co  B2   (g_Var_f c) )   R )  ->
      ( forall c , c \notin  L  ->  (  ( open_tm_wrt_co B3 (g_Var_f c) )   =   (open_tm_wrt_co  B2   (g_Cast (g_Var_f c) (g_Sym g1)) )  )  )  ->
     AnnTyping G (a_CPi phi1 B1) a_Star R ->
      ( AnnTyping G (a_CPi phi2 B3) a_Star R )  ->
     AnnTyping G (a_CPi phi1 B2) a_Star R ->
     AnnDefEq G D  ( (g_CPiCong g1 g3) )   ( (a_CPi phi1 B1) )   ( (a_CPi phi2 B3) )  R
 | An_CAbsCong : forall (L:vars) (G:context) (D:available_props) (g1 g3 g4:co) (phi1:constraint) (a1:tm) (phi2:constraint) (a3:tm) (R:role) (a2 B1 B B2:tm),
     AnnIso G D g1 phi1 phi2 ->
      ( forall c , c \notin  L  -> AnnDefEq  (( c ~ Co  phi1 ) ++  G )  D  ( open_co_wrt_co g3 (g_Var_f c) )   ( open_tm_wrt_co a1 (g_Var_f c) )    (open_tm_wrt_co  a2   (g_Var_f c) )   R )  ->
      ( forall c , c \notin  L  ->  (  ( open_tm_wrt_co a3 (g_Var_f c) )   =   (open_tm_wrt_co  a2   (g_Cast (g_Var_f c) (g_Sym g1)) )  )  )  ->
     AnnTyping G  ( (a_CAbs phi1 a1) )  (a_CPi phi1 B1) R ->
     AnnTyping G  ( (a_CAbs phi1 a2) )  B R ->
     AnnTyping G  ( (a_CAbs phi2 a3) )  (a_CPi phi2 B2) R ->
     AnnDefEq G  (dom  G )  g4 (a_CPi phi1 B1) (a_CPi phi2 B2) R ->
     AnnDefEq G D  ( (g_CAbsCong g1 g3 g4) )   ( (a_CAbs phi1 a1) )   ( (a_CAbs phi2 a3) )  R
 | An_CAppCong : forall (G:context) (D:available_props) (g1 g2 g3:co) (a1 b1:tm) (R:role) (a2 b2:tm) (R':role) (a3 b3 A B:tm) (g4:co),
     AnnDefEq G D g1 a1 b1 R ->
     AnnDefEq G  (dom  G )  g2 a2 b2 R' ->
     AnnDefEq G  (dom  G )  g3 a3 b3 R' ->
     AnnTyping G (a_CApp a1 g2) A R ->
     AnnTyping G (a_CApp b1 g3) B R ->
      ( AnnDefEq G  (dom  G )  g4 A B R )  ->
     AnnDefEq G D (g_CAppCong g1 g2 g3) (a_CApp a1 g2) (a_CApp b1 g3) R
 | An_CPiSnd : forall (G:context) (D:available_props) (g1 g2 g3:co) (B1 B2:tm) (R0:role) (a a' A:tm) (R:role) (b b' B:tm) (R':role),
     AnnDefEq G D g1  ( (a_CPi (Eq a a' A R) B1) )   ( (a_CPi (Eq b b' B R') B2) )  R0 ->
     AnnDefEq G  (dom  G )  g2 a a' R ->
     AnnDefEq G  (dom  G )  g3 b b' R' ->
     AnnDefEq G D (g_CPiSnd g1 g2 g3)  (open_tm_wrt_co  B1   g2 )   (open_tm_wrt_co  B2   g3 )  R0
 | An_Cast : forall (G:context) (D:available_props) (g1 g2:co) (b b':tm) (R2:role) (a a':tm) (R1:role) (A B:tm),
     AnnDefEq G D g1 a a' R1 ->
     AnnIso G D g2 (Eq a a' A R1) (Eq b b' B R2) ->
     AnnDefEq G D (g_Cast g1 g2) b b' R2
 | An_IsoSnd : forall (G:context) (D:available_props) (g:co) (A B:tm) (R0:role) (a a':tm) (R1:role) (b b':tm) (R2:role),
     AnnIso G D g  ( (Eq a a' A R1) )   ( (Eq b b' B R2) )  ->
     SubRole R1 R0 ->
     SubRole R2 R0 ->
     AnnDefEq G D (g_IsoSnd g) A B R0
with AnnCtx : context -> Prop :=    (* defn AnnCtx *)
 | An_Empty : 
     AnnCtx  nil 
 | An_ConsTm : forall (G:context) (x:tmvar) (A:tm) (R:role),
     AnnCtx G ->
     AnnTyping G A a_Star R ->
      ~ AtomSetImpl.In  x  (dom  G )  ->
     AnnCtx  (( x ~ Tm  A R ) ++  G ) 
 | An_ConsCo : forall (G:context) (c:covar) (phi:constraint),
     AnnCtx G ->
     AnnPropWff G phi ->
      ~ AtomSetImpl.In  c  (dom  G )  ->
     AnnCtx  (( c ~ Co  phi ) ++  G ) 
with AnnSig : sig -> Prop :=    (* defn AnnSig *)
 | An_Sig_Empty : 
     AnnSig  nil 
 | An_Sig_ConsAx : forall (S:sig) (F:tyfam) (a A:tm) (R:role),
     AnnSig S ->
     AnnTyping  nil  A a_Star R ->
     AnnTyping  nil  a A R ->
      ~ AtomSetImpl.In  F  (dom  S )  ->
     AnnSig  (( F ~ Ax a A R )++ S ) .

(* defns Jred *)
Inductive head_reduction : context -> tm -> tm -> Prop :=    (* defn head_reduction *)
 | An_AppLeft : forall (G:context) (a:tm) (rho:relflag) (b a':tm),
     lc_tm b ->
     head_reduction G a a' ->
     head_reduction G (a_App a rho b) (a_App a' rho b)
 | An_AppAbs : forall (G:context) (rho:relflag) (A:tm) (R:role) (w a:tm),
     lc_tm a ->
     Value  ( (a_Abs rho A R w) )  ->
     head_reduction G (a_App  ( (a_Abs rho A R w) )  rho a)  (open_tm_wrt_tm  w   a ) 
 | An_CAppLeft : forall (G:context) (a:tm) (g:co) (a':tm),
     lc_co g ->
     head_reduction G a a' ->
     head_reduction G (a_CApp a g) (a_CApp a' g)
 | An_CAppCAbs : forall (G:context) (phi:constraint) (b:tm) (g:co),
     lc_constraint phi ->
     lc_tm (a_CAbs phi b) ->
     lc_co g ->
     head_reduction G (a_CApp  ( (a_CAbs phi b) )  g)  (open_tm_wrt_co  b   g ) 
 | An_AbsTerm : forall (L:vars) (G:context) (A:tm) (R:role) (b b':tm),
     AnnTyping G A a_Star R ->
      ( forall x , x \notin  L  -> head_reduction  (( x ~ Tm  A R ) ++  G )   ( open_tm_wrt_tm b (a_Var_f x) )   ( open_tm_wrt_tm b' (a_Var_f x) )  )  ->
     head_reduction G  ( (a_Abs Irrel A R b) )   ( (a_Abs Irrel A R b') ) 
 | An_Axiom : forall (G:context) (F:tyfam) (a A:tm) (R:role),
      binds  F  (Ax  a A R )   an_toplevel   ->
     head_reduction G (a_Fam F) a
 | An_ConvTerm : forall (G:context) (a:tm) (g:co) (a':tm),
     lc_co g ->
     head_reduction G a a' ->
     head_reduction G (a_Conv a g) (a_Conv a' g)
 | An_Combine : forall (G:context) (v:tm) (g1 g2:co),
     lc_co g1 ->
     lc_co g2 ->
     Value v ->
     head_reduction G (a_Conv  ( (a_Conv v g1) )  g2) (a_Conv v  ( (g_Trans g1 g2) ) )
 | An_Push : forall (G:context) (v:tm) (g:co) (rho:relflag) (b b':tm) (g':co) (A1:tm) (R1:role) (B1 A2:tm) (R2:role) (B2:tm) (R:role),
     Value v ->
     AnnDefEq G  (dom  G )  g (a_Pi rho A1 R1 B1) (a_Pi rho A2 R2 B2) R ->
      ( b'  =  (a_Conv b (g_Sym  ( (g_PiFst g) ) )) )  ->
      ( g'  =  (g_PiSnd g (g_Refl2 b' b  ( (g_PiFst g) ) )) )  ->
     head_reduction G (a_App  ( (a_Conv v g) )  rho b) (a_Conv  ( (a_App v rho b') )  g')
 | An_CPush : forall (G:context) (v:tm) (g g1 g1' g':co) (phi1:constraint) (A1:tm) (phi2:constraint) (A2:tm) (R:role),
     Value v ->
     AnnDefEq G  (dom  G )  g (a_CPi phi1 A1) (a_CPi phi2 A2) R ->
      ( g1'  =  (g_Cast g1 (g_Sym  ( (g_CPiFst g) ) )) )  ->
      ( g'  =  (g_CPiSnd g g1' g1) )  ->
     head_reduction G (a_CApp  ( (a_Conv v g) )  g1) (a_Conv  ( (a_CApp v g1') )  g').


(** infrastructure *)
Hint Constructors SubRole CoercedValue Value value_type consistent erased_tm RhoCheck Par MultiPar joins Beta reduction_in_one reduction PropWff Typing Iso DefEq Ctx Sig AnnPropWff AnnTyping AnnIso AnnDefEq AnnCtx AnnSig head_reduction lc_co lc_brs lc_tm lc_constraint lc_sort lc_sig_sort.


