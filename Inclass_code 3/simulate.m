%% File Info.

%{

    simulate.m
    ----------
    This code simulates the model.

%}

%% Simulate class.

classdef simulate
    methods(Static)
        %% Simulate the model. 
        
        function sim = firm_dynamics(par,sol)            
            %% Set up.
            
            kgrid = par.kgrid; % Capital today (state variable).
            Agrid = par.Agrid; % Productivity (state variable).

            vpol = sol.v; % Firm value.
            kpol = sol.k; % Policy function for capital.
            ipol = sol.i; % Policy function for investment.
            rpol = sol.r; % Optimal revenue.
            epol = sol.e; % Optimal total investment expenditure.
            ppol = sol.p; % Optimal profit.

            T = par.T; % Time periods.
            N = par.N; %Number of firms.
            Asim = zeros(T*2,N); % Container for simulated productivity.
            vsim = zeros(T*2,N); % Container for simulated firm value.
            rsim = zeros(T*2,N); % Container for simulated output.
            ksim = zeros(T*2,N); % Container for simulated capital stock.
            isim = zeros(T*2,N); % Container for simulated investment.
            esim = zeros(T*2,N); % Container for simulated investment expenditure.
            psim = zeros(T*2,N); % Container for simulated profit.
            
            %% Begin simulation.
            
            rng(par.seed);

            pmat0 = par.pmat^1000;
            pmat0 = pmat0(1,:); % Stationary distribution.
            cmat = cumsum(par.pmat,2); % CDF matrix.

            k0_ind = randsample(par.klen,N); % Index for initial capital stock.
            A0_ind = randsample(par.Alen,N,true,pmat0); % Index for initial productivity.                

            for i = 1:N
            Asim(1,i) = Agrid(A0_ind(i)); % Productivity in period 1.
            vsim(1,i) = vpol(k0_ind(i),A0_ind(i)); % Firm value in period 1 given k0 and A0.
            ksim(1,i) = kpol(k0_ind(i),A0_ind(i)); % Capital choice for period 2 given k0 and A0.
            isim(1,i) = ipol(k0_ind(i),A0_ind(i)); % Investment in period 1 given k0 and A0.
            rsim(1,i) = rpol(k0_ind(i),A0_ind(i)); % Revenue in period 1 given k0 and A0.
            esim(1,i) = ipol(k0_ind(i),A0_ind(i)); % Investment ependiture in period 1 given k0 and A0.
            psim(1,i) = ppol(k0_ind(i),A0_ind(i)); % Utility in period 1 given k0 and A0.

            A1_ind = find(rand<=cmat(A0_ind(i),:)); % Draw productivity for next period.
            A0_ind(i) = A1_ind(1);
            end

   

            %% Simulate endogenous and exogenous variables.

            for j = 2:T*2 % Time loop. 
                for i = 1:N %Firms loop
                kt_ind = find(ksim(j-1,i)==kgrid); % Capital choice in the previous period is the state today. Find where the latter is on the grid.
                Asim(j,i) = Agrid(A0_ind(i))/N; % Productivity in period t.
                vsim(j,i) = vpol(kt_ind,A0_ind(i)); % Firm value in period t.
                ksim(j,i) = kpol(kt_ind,A0_ind(i)); % Capital stock for period t+1.
                isim(j,i) = ipol(kt_ind,A0_ind(i)); % Investment in period t.
                rsim(j,i) = rpol(kt_ind,A0_ind(i)); % Revenue in period t.
                esim(j,i) = epol(kt_ind,A0_ind(i)); % Investment expenditure in period t.
                psim(j,i) = ppol(kt_ind,A0_ind(i)); % Profit in period t.
                A1_ind = find(rand<=cmat(A0_ind(i),:)); % Draw next state.
                A0_ind(i) = A1_ind(1); % State next period.
                end
            end

            sim = struct();
            
            % Burn the first half.
            sim.Asim = Asim(T+1:2*T,:); % Simulated productivity.
            sim.vsim = vsim(T+1:2*T,:); % Simulated output.
            sim.ksim = ksim(T+1:2*T,:); % Simulated capital choice.
            sim.isim = isim(T+1:2*T,:); % Simulated investment.
            sim.rsim = rsim(T+1:2*T,:); % Simulated revenue.
            sim.esim = esim(T+1:2*T,:); % Simulated investment expenditure.
            sim.psim = psim(T+1:2*T,:); % Simulated profit.
             
        end
        
    end
end