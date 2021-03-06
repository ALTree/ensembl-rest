require_relative 'helper'

class TestLookup < Test::Unit::TestCase

  context 'lookup_id' do 

    setup do 
      EnsemblRest.connect_db
    end

    should 'support a basic call and return the correct data' do
      look = Lookup.lookup_id 'ENSG00000157764'
      assert look.index 'Gene'                # we asked for a gene
      assert look.index 'core'                # db_type should be this
      assert look.index 'homo_sapiens'        # we used a human stable ID  
      assert look.index 'ENSG00000157764'     # exactly this one
    end

    sleep(1)

    should 'support the full parameter' do 
      look_plain = Lookup.lookup_id 'ENSG00000157764', format: 'condensed'
      look_full = Lookup.lookup_id 'ENSG00000157764', format: 'full'
      assert look_full.size > look_plain.size
    end

    sleep(1)

    should 'return the right object' do 
      look = JSON.parse Lookup.lookup_id 'ENSG00000157764', format: 'full'
      assert look['object_type'].casecmp 'gene'
      assert look['species'].casecmp 'homo_sapiens'
      assert look['start'] = 140424943
      assert look['end'] = 140624564
    end

    should 'support db_type parameter' do 
      look = JSON.parse Lookup.lookup_id 'ENSG00000157764', db_type: 'core'
      assert look['db_type'] = 'core'
    end

    sleep(1)

  end

  context 'lookup_symbol' do 

    setup do 
      EnsemblRest.connect_db
    end

    should 'support a basic call and return the correct data' do
      look = Lookup.lookup_symbol 'human', 'BRCA2'
      assert look.index 'Gene'                # we asked for a gene
      assert look.index 'core'                # db_type should be this
      assert look.index 'human'               # we used a human stable ID  
      assert look.index 'ENSG00000139618'     # exactly this one
    end

    sleep(1)
  end

end
