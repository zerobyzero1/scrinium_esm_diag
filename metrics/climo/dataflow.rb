module ScriniumEsmDiag
  class Dataflow_climo < Dataflow
    create_dataset :atm, :monthly do
      requires :PS, :PRECC, :PRECL, :PRECT, :SWCF, :LWCF, :U, :V, :T, :Q, :FLUT, :FSNTOA
      extract :all
      vinterp :U, :V, {
        :on => [ 1000, 925, 850, 775, 700, 600, 500, 400, 300, 250, 200, 150, 100, 70, 50, 30, 10],
        :interp_type => :linear,
        :extrap => false
      }
      vinterp :Q, {
        :on => [ 1000, 925, 850, 775, 700, 600, 500, 400, 300 ],
        :interp_type => :linear,
        :extrap => false
      }
      vinterp :T, {
        :on => [ 1000, 925, 850, 775, 700, 600, 500, 400, 300, 250, 200, 150, 100, 70, 50, 30, 10],
        :interp_type => :log,
        :extrap => false
      }
    end
  end
end
