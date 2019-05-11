!    Copyright (C) 2012 The SPEED FOUNDATION
!    Author: Ilario Mazzieri
!
!    This file is part of SPEED.
!
!    SPEED is free software; you can redistribute it and/or modify it
!    under the terms of the GNU Affero General Public License as
!    published by the Free Software Foundation, either version 3 of the
!    License, or (at your option) any later version.
!
!    SPEED is distributed in the hope that it will be useful, but
!    WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
!    Affero General Public License for more details.
!
!    You should have received a copy of the GNU Affero General Public License
!    along with SPEED.  If not, see <http://www.gnu.org/licenses/>.

!> @brief Computes spatial derivatives of displacement.
!! @author Ilario Mazzieri
!> @date September, 2013
!> @version 1.0
!> @param[in] nn number of 1-D Legendre nodes
!> @param[in] ct GLL nodes
!> @param[in] ww GLL weights
!> @param[in] dd matrix of spectral derivatives
!> @param[in] ux x-displacement
!> @param[in] uy y-displacement
!> @param[in] uy z-displacement
!> @param[in] alfa11 costant for the bilinear map
!> @param[in] alfa12 costant for the bilinear map
!> @param[in] alfa13 costant for the bilinear map
!> @param[in] alfa21 costant for the bilinear map
!> @param[in] alfa22 costant for the bilinear map
!> @param[in] alfa23 costant for the bilinear map
!> @param[in] alfa31 costant for the bilinear map
!> @param[in] alfa32 costant for the bilinear map
!> @param[in] alfa33 costant for the bilinear map
!> @param[in] beta11 costant for the bilinear map
!> @param[in] beta12 costant for the bilinear map
!> @param[in] beta13 costant for the bilinear map
!> @param[in] beta21 costant for the bilinear map
!> @param[in] beta22 costant for the bilinear map
!> @param[in] beta23 costant for the bilinear map
!> @param[in] beta31 costant for the bilinear map
!> @param[in] beta32 costant for the bilinear map
!> @param[in] beta33 costant for the bilinear map
!> @param[in] gamma1  costant for the bilinear map
!> @param[in] gamma2  costant for the bilinear map
!> @param[in] gamma3  costant for the bilinear map
!> @param[in] delta1  costant for the bilinear map
!> @param[in] delta2  costant for the bilinear map
!> @param[in] delta3  costant for the bilinear map
!> @param[out] duxdx nodal values for spatial derivatives of the displacement 
!> @param[out] duydx nodal values for spatial derivatives of the displacement
!> @param[out] duzdx nodal values for spatial derivatives of the displacement
!> @param[out] duxdy nodal values for spatial derivatives of the displacement
!> @param[out] duydy nodal values for spatial derivatives of the displacement
!> @param[out] duzdy nodal values for spatial derivatives of the displacement
!> @param[out] duxdz nodal values for spatial derivatives of the displacement
!> @param[out] duydz nodal values for spatial derivatives of the displacement      
!> @param[out] duzdz nodal values for spatial derivatives of the displacement


      subroutine MAKE_STRAIN_TENSOR(nn,ct,ww,dd,&
                               alfa11,alfa12,alfa13,alfa21,alfa22,alfa23,&
                               alfa31,alfa32,alfa33,beta11,beta12,beta13,&
                               beta21,beta22,beta23,beta31,beta32,beta33,&
                               gamma1,gamma2,gamma3,delta1,delta2,delta3,&
                               ux,uy,uz,&
                               duxdx,duydx,duzdx,&
                               duxdy,duydy,duzdy,&
                               duxdz,duydz,duzdz)   
      
      implicit none
      
      integer*4 :: nn
      integer*4 :: i,j,k,p,q,r

      real*8 :: alfa11,alfa12,alfa13,alfa21,alfa22,alfa23,alfa31,alfa32,alfa33
      real*8 :: beta11,beta12,beta13,beta21,beta22,beta23,beta31,beta32,beta33
      real*8 :: gamma1,gamma2,gamma3,delta1,delta2,delta3
      real*8 :: dxdx,dxdy,dxdz,dydx,dydy,dydz,dzdx,dzdy,dzdz,det_j
      real*8 :: t1ux,t2ux,t3ux,t1uy,t2uy,t3uy,t1uz,t2uz,t3uz

      real*8, dimension(nn) :: ct,ww
      real*8, dimension(nn,nn) :: dd

      real*8, dimension(nn,nn,nn) :: ux,uy,uz
      real*8, dimension(nn,nn,nn) :: duxdx,duxdy,duxdz,duydx,duydy,duydz,duzdx,duzdy,duzdz
      
!     STRAIN CALCULATION
      
      do r = 1,nn
         do q = 1,nn
            do p = 1,nn
               t1ux = 0.d0
               t1uy = 0.d0
               t1uz = 0.d0
               t2ux = 0.d0
               t2uy = 0.d0
               t2uz = 0.d0
               t3ux = 0.d0
               t3uy = 0.d0
               t3uz = 0.d0
               
               dxdx = alfa11 + beta12*ct(r) + beta13*ct(q) &
                    + gamma1*ct(q)*ct(r)
               dydx = alfa21 + beta22*ct(r) + beta23*ct(q) &
                    + gamma2*ct(q)*ct(r)
               dzdx = alfa31 + beta32*ct(r) + beta33*ct(q) &
                    + gamma3*ct(q)*ct(r)
               
               dxdy = alfa12 + beta11*ct(r) + beta13*ct(p) &
                    + gamma1*ct(r)*ct(p)
               dydy = alfa22 + beta21*ct(r) + beta23*ct(p) &
                    + gamma2*ct(r)*ct(p)
               dzdy = alfa32 + beta31*ct(r) + beta33*ct(p) &
                    + gamma3*ct(r)*ct(p)
               
               dxdz = alfa13 + beta11*ct(q) + beta12*ct(p) &
                    + gamma1*ct(p)*ct(q)
               dydz = alfa23 + beta21*ct(q) + beta22*ct(p) &
                    + gamma2*ct(p)*ct(q)
               dzdz = alfa33 + beta31*ct(q) + beta32*ct(p) &
                    + gamma3*ct(p)*ct(q)
               
               det_j = dxdz * (dydx*dzdy - dzdx*dydy) &
                     - dydz * (dxdx*dzdy - dzdx*dxdy) &
                     + dzdz * (dxdx*dydy - dydx*dxdy)
               
               
               do i = 1,nn
                  t1ux = t1ux + ux(i,q,r) * dd(p,i)
                  t1uy = t1uy + uy(i,q,r) * dd(p,i)
                  t1uz = t1uz + uz(i,q,r) * dd(p,i)
               enddo
               
               do j = 1,nn
                  t2ux = t2ux + ux(p,j,r) * dd(q,j)
                  t2uy = t2uy + uy(p,j,r) * dd(q,j)
                  t2uz = t2uz + uz(p,j,r) * dd(q,j)
               enddo
               
               do k = 1,nn
                  t3ux = t3ux + ux(p,q,k) * dd(r,k)
                  t3uy = t3uy + uy(p,q,k) * dd(r,k)
                  t3uz = t3uz + uz(p,q,k) * dd(r,k)
               enddo
               
               
               duxdx(p,q,r) = 1.0d0 / det_j *(&
                    ((dydy*dzdz - dydz*dzdy) * t1ux) + &
                    ((dydz*dzdx - dydx*dzdz) * t2ux) + &
                    ((dydx*dzdy - dydy*dzdx) * t3ux))
               
               duydx(p,q,r) = 1.0d0 / det_j *(&
                    ((dydy*dzdz - dydz*dzdy) * t1uy) + &
                    ((dydz*dzdx - dydx*dzdz) * t2uy) + &
                    ((dydx*dzdy - dydy*dzdx) * t3uy))
               
               duzdx(p,q,r) = 1.0d0 / det_j *(&
                    ((dydy*dzdz - dydz*dzdy) * t1uz) + &
                    ((dydz*dzdx - dydx*dzdz) * t2uz) + &
                    ((dydx*dzdy - dydy*dzdx) * t3uz))
               
               duxdy(p,q,r) = 1.0d0 / det_j *(&
                    ((dzdy*dxdz - dzdz*dxdy) * t1ux) + &
                    ((dzdz*dxdx - dzdx*dxdz) * t2ux) + &
                    ((dzdx*dxdy - dzdy*dxdx) * t3ux))
               
               duydy(p,q,r) = 1.0d0 / det_j *(&
                    ((dzdy*dxdz - dzdz*dxdy) * t1uy) + &
                    ((dzdz*dxdx - dzdx*dxdz) * t2uy) + &
                    ((dzdx*dxdy - dzdy*dxdx) * t3uy))
               
               duzdy(p,q,r) = 1.0d0 / det_j *(&
                    ((dzdy*dxdz - dzdz*dxdy) * t1uz) + &
                    ((dzdz*dxdx - dzdx*dxdz) * t2uz) + &
                    ((dzdx*dxdy - dzdy*dxdx) * t3uz))
               
               duxdz(p,q,r) = 1.0d0 / det_j *(&
                    ((dxdy*dydz - dxdz*dydy) * t1ux) + &
                    ((dxdz*dydx - dxdx*dydz) * t2ux) + &
                    ((dxdx*dydy - dxdy*dydx) * t3ux))
               
               duydz(p,q,r) = 1.0d0 / det_j *(&
                    ((dxdy*dydz - dxdz*dydy) * t1uy) + &
                    ((dxdz*dydx - dxdx*dydz) * t2uy) + &
                    ((dxdx*dydy - dxdy*dydx) * t3uy))
               
               duzdz(p,q,r) = 1.0d0 / det_j *(&
                    ((dxdy*dydz - dxdz*dydy) * t1uz) + &
                    ((dxdz*dydx - dxdx*dydz) * t2uz) + &
                    ((dxdx*dydy - dxdy*dydx) * t3uz))
                              
            enddo
         enddo
      enddo
      
      return
      
      end subroutine MAKE_STRAIN_TENSOR

