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
(*
Lemma uniq_an_toplevel : uniq an_toplevel.
Proof.
 induction AnnSig_an_toplevel; auto.
Qed. *)
Lemma uniq_toplevel : uniq toplevel.
Proof.
  induction Sig_toplevel; auto.
Qed.
(*
(* ------------------------------------------ *)
Lemma toplevel_closed : forall F p a A R Rs, binds F (Ax p a A R Rs) toplevel ->
                                 Typing nil a A.
Proof.
  have st: Sig toplevel by apply Sig_toplevel.
  induction st.
  - intros. inversion H.
  - intros. eapply IHst. inversion H1; subst.
    inversion H2. eauto.
  - intros.
    match goal with [ H : binds ?F _ _ |- _ ] => inversion H end.
    match goal with [ H : (_,_) = (_,_) |- _ ] => inversion H end.
    subst. eauto. eauto.
Qed.

Lemma toplevel_closed_const : forall F A, binds F (Cs A) toplevel ->
                                 Typing nil A a_Star Rep.
Proof.
  have st: Sig toplevel by apply Sig_toplevel.
  induction st.
  - intros. inversion H.
  - intros.
    match goal with [ H : binds ?F _ _ |- _ ] => inversion H end.
    match goal with [ H : (_,_) = (_,_) |- _ ] => inversion H end.
    subst. eauto. eauto.
  - intros. eapply IHst. inversion H1; subst.
    inversion H2. eauto.
Qed.


Lemma an_toplevel_closed : forall F a A R, binds F (Ax a A R) an_toplevel ->
                                    AnnTyping nil a A R.
Proof.
  have st: AnnSig an_toplevel by apply AnnSig_an_toplevel.
  induction st.
  - intros. inversion H.
  - intros.
    match goal with [ H : binds ?F _ _ |- _ ] => inversion H end.
    match goal with [ H : (_,_) = (_,_) |- _ ] => inversion H end.
    subst. eauto. eauto.
Qed. *)
