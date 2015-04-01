#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"


MODULE = Random		PACKAGE = Random		


void
choice(num,...)
    SV *num
PROTOTYPE: $@
PPCODE:
{
	int index;
#if (PERL_VERSION < 9)
    struct op dmy_op;
    struct op *old_op = PL_op;

    /* We call pp_rand here so that Drand01 get initialized if rand()
       or srand() has not already been called
    */
    memzero((char*)(&dmy_op), sizeof(struct op));
    /* we let pp_rand() borrow the TARG allocated for this XS sub */
    dmy_op.op_targ = PL_op->op_targ;
    PL_op = &dmy_op;
    (void)*(PL_ppaddr[OP_RAND])(aTHX);
    PL_op = old_op;
#else
    /* Initialize Drand01 if rand() or srand() has
       not already been called
    */
    if(!PL_srand_called) {
        (void)seedDrand01((Rand_seed_t)Perl_seed(aTHX));
        PL_srand_called = TRUE;
    }
#endif

    int max = SvIV(num);
    int random_scope = items - 1;
    for ( int i = 0; i < max; ++i ) {
        int swap   = (int)(Drand01() * (double)(random_scope--)) + (i + 1);
        SV* choice = ST(swap);
        ST(swap)   = ST(i);
        
        ST(i) = sv_2mortal(newSVsv(choice));
    }
    XSRETURN(max);
}
