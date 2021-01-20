      module Initialization
      ! Initialize the simulation:
      ! - Set global options (thread number, time loop counter, initial
      !                       initial momentum variation)
      ! - Construct spatial grid
      ! - Construct energy grids for ionization equilibrium
      ! - Construct initial conditions (load or set)
      
      use global_parameters
      use grid_construction
      use energy_vectors_construct
      use initial_conditions
      use Conversion
      use BC_Apply
      use omp_lib
      use IC_load
      use initial_conditions
      
      implicit none 
      
      contains
      
      subroutine init(W,u,f_sp)
      integer :: j
      character(len=1) :: ans  
      real*8, dimension(1-Ng:N+Ng)   :: rho,v,E,p,T
      real*8, dimension(1-Ng:N+Ng,5),intent(out) :: f_sp
      real*8, dimension(1-Ng:N+Ng,3),intent(out) :: W,u    
         
      ! Global options
      
      ! Set the number of threads used 
     	call omp_set_num_threads(4)
      
      ! Loop parameters
      count = 0  
      du = 1.0
      
      
      !------------------------------------------------!
      
      ! Construction of radial grid
      call define_grid         
      
      !------------------------------------------------!
      
      ! Construction of energy grid
      call set_energy_vectors      
      
      !------------------------------------------------!
      
      !---- Initial conditions ----!
      
      write(*,*) "Do you want to load existing ICs?"
      read(*,*) ans
      
      
      if (ans.eq.'n') then
      
      	 call set_IC(W,T,f_sp)
      
      else ! Load existing initial conditions
            
	      ! Load thermodynamic profiles
	      call load_IC(rho,v,p,T,f_sp,W)      
	                  
	      ! Change starting loop counting index
	      count = 1
    	
    	endif
      
      !------------------------------------------------!

      ! Apply BC to initial condition
      call W_to_U(W,u)
      call Apply_BC(u,u)
      
         
            
      end subroutine init
      
      end module Initialization
