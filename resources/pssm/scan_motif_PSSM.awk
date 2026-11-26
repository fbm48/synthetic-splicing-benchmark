#!/usr/bin/awk -f

# example:
# scan_motif_PSSM.awk POS=1 CUTOFF=0.8 FILTER=...GT.... Donor.PSSM GeneArt_72_and_96_GFP_Variants.tab

# prints motif scores for set of sequences
# input 1: PSSM file (tab separated with 4 numbers (A, C, G, and T percentages) in each row)
# input 2: sequence file in tab format
# output: list of motifs and scores

# options:
# POS: only motifs at this position are printed
# CUTOFF: only motifs with at least that score are printed
# FILTER: only motifs matching this regex are printed

BEGIN{
	CUTOFF = ""
	FILTER = ""
	POS = ""
}


NR==FNR{
	PSSM["A"][FNR-1]=$1
	PSSM["C"][FNR-1]=$2
	PSSM["G"][FNR-1]=$3
	PSSM["T"][FNR-1]=$4
	PSSM_len++
}

NR!=FNR && FNR==1{
	for(i=0;i<PSSM_len;i++){
		PSSM_min+=min(PSSM["A"][i],PSSM["C"][i],PSSM["G"][i],PSSM["T"][i])
		PSSM_max+=max(PSSM["A"][i],PSSM["C"][i],PSSM["G"][i],PSSM["T"][i])
	}	
#	print "MIN: " PSSM_min
#	print "MAX: " PSSM_max
}


NR!=FNR{
	nm=$1
	len=length($2)
	split($2,seq,"")
	for(i=1;i<=len-PSSM_len;i++){
		curr_motif=substr($2,i,PSSM_len)
		score=0
		for(j=0;j<PSSM_len;j++){
			score+=PSSM[seq[i+j]][j]
		}
		norm_score = (score-PSSM_min)/(PSSM_max-PSSM_min)
		if( !CUTOFF || norm_score >= CUTOFF ){
			if(!FILTER || match(curr_motif, FILTER)){
				if(!POS || i==POS){
					print nm "\t" i "\t" curr_motif "\t" norm_score
				}
			}
		}
	}
}

END{
	for(i=0;i<PSSM_len;i++){
#		print "A: " PSSM["A"][i] "\tC: " PSSM["C"][i] "\tG: " PSSM["G"][i] "\tT: " PSSM["T"][i]
	}
}

function min(a,b,c,d){
	if(a<=b && a<=c && a<=d){return a}
	if(b<=c && b<=d){return b}
	if(c<=d){return c}
	return d
}

function max(a,b,c,d){
	if(a>=b && a>=c && a>=d){return a}
	if(b>=c && b>=d){return b}
	if(c>=d){return c}
	return d
}

