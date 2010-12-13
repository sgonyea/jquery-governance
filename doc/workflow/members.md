# Instantiation

## Member Creation

### Workflow

1.  A motion is made to invite a new Member
    *   Full Name and E-Mail are supplied as part of the motion?
    *   "Special Motions" vs. "Regular Motions"?

2.  A new Member is created, representing the person. 

3.  If the motion passes, an Active Membership is then created and associated with the Member and the Motion

4.  An e-mail is dispatched, with a link to assign credentials

    *   Policy Acceptance? Rules acknowledgement?

### Ideas

*   Before a vote is brought, should the Member:
    *   Accept policies or rules?
    *   Declare any conflicts of interest they might have (Full Disclosure)?

## Member Destruction

1.  A member may resign his/her membership at any time.

2.  Otherwise, a vote must be cast

3.  If passed, the Active Membership must either:
    *   Be "deleted", except really acts\_as\_versioned
    *   Have an "ended at" timestamp set, which will cause their Member instance to be filtered out.

# Constraints

1.  A member can have many "memberships" (historically)
    *   Only one of those memberships (the most recent) can actually be active.

2.  Members should be hidden from the wider view, except in a timeline ?





