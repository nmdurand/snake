export default (n, block)->
	accum = ''
	for i in [0...n]
		accum += block.fn(i)
	accum
