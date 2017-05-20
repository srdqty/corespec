Set Bullet Behavior "Strict Subproofs".
Set Implicit Arguments.

Require Export FcEtt.tactics.
Require Export FcEtt.imports.
Require Export FcEtt.ett_inf.
Require Export FcEtt.ett_ott.
Require Export FcEtt.ett_ind.
Require Import FcEtt.utils.

Require Export FcEtt.fix_typing.


(**** Facts about toplevel signatures ****)


(* --------------------------------------------------- *)

Lemma uniq_an_toplevel : uniq an_toplevel.
Proof.
 induction AnnSig_an_toplevel; auto.
Qed.
Lemma uniq_toplevel : uniq toplevel.
Proof.
  induction Sig_toplevel; auto.
Qed.

(* ------------------------------------------ *)
Lemma toplevel_closed : forall F a A, binds F (Ax a A) toplevel ->
                                 Typing nil a A.
Proof.
  have st: Sig toplevel by apply Sig_toplevel.
  induction st.
  - intros. inversion H.
  - intros. inversion H2. inversion H3. subst. eauto. eauto.
Qed.


Lemma an_toplevel_closed : forall F a A, binds F (Ax a A) an_toplevel ->
                                    AnnTyping nil a A.
Proof.
  have st: AnnSig an_toplevel by apply AnnSig_an_toplevel.
  induction st.
  - intros. inversion H.
  - intros. inversion H2. inversion H3. subst. eauto. eauto.
Qed.
