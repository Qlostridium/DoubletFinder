nextflow.preview.dsl=2

include {
	DOUBLETFINDER__RUN
} from './processes/doubletFinder.nf' params(params)

workflow {
	input = Channel.fromPath(params.global.inputFile)
						.map{ file -> tuple(params.global.sampleName,file)}

	DOUBLETFINDER__RUN(input)
}
