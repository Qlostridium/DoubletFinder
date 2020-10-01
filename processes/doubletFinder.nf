nextflow.preview.dsl=2

scriptDir = (params.global.standAlone == true) ? "${params.global.rundir}/bin": "${params.global.rundir}/src/DoubletFinder/bin"

process DOUBLETFINDER__RUN {
	publishDir "${params.global.outdir}/${samplename}", mode: 'symlink', pattern: "Plots/**"
	container params.DoubletFinder.container
	input:
	tuple val(samplename), file(sobj)
	output:
	tuple val(samplename), file("${samplename}.DOUBLETFINDER.rds")
	file("Plots/**")
	script:
	def sampleParams = params.configParser(samplename, params.DoubletFinder)
	"""
	Rscript ${scriptDir}/doubletFinder.R --seuratObj ${sobj} \
	--output ${samplename}.DOUBLETFINDER.rds \
	${(sampleParams.minPCT == null) ? '' : '--minPCT ' + sampleParams.minPCT} \
	${(sampleParams.maxPCT == null) ? '' : '--maxPCT ' + sampleParams.maxPCT} \
	${(sampleParams.pN == null) ? '' : '--pN ' + sampleParams.pN} \
	${(sampleParams.dimsToUse == null) ? '' : '--dimsToUse ' + sampleParams.dimsToUse} \
	${(sampleParams.cores == null) ? '' : '--cores ' + sampleParams.cores}
	"""
}
