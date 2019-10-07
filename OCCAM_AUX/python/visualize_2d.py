import numpy as np
import itertools
import matplotlib.pyplot as plt
import matplotlib.transforms as trs
from mpl_toolkits.mplot3d import Axes3D  # noqa: F401
from bayes_opt import UtilityFunction

def posterior(optimizer, x_observed, y_observed, target_observed,
              design_matrix):
    var_observed = np.hstack((x_observed, y_observed))
    optimizer._gp.fit(var_observed, target_observed)
    mu, sigma = optimizer._gp.predict(design_matrix, return_std=True)
    return mu, sigma
 
class PlotProgress_2D:
    def __init__(self, optimizer, true_function=None, cost=None):
        self.optimizer = optimizer
        self.true_function = true_function
        self.cost = cost
        self.phi, self.theta = 30, 45  # Default 3D plot camera rotations
        self.N = 100
        self._first_plot = True
        self.target_space = optimizer._space
        self.bounds = self.target_space._bounds
        self.axis_names = self.target_space._keys
        if self.target_space.dim != 2:
            raise NotImplementedError('3d or higher dimensional visualization '
                                      'not supported.')

    def plot(self):
        if self._first_plot:
            self._setup_first()
        self._update_plots()
        self._first_plot = False
        plt.pause(0.0001)

    def _setup_grid(self):
        self.X_ = np.linspace(self.bounds[0][0], self.bounds[0][1], self.N)
        self.Y_ = np.linspace(self.bounds[1][0], self.bounds[1][1], self.N)
        self.X, self.Y = np.meshgrid(self.X_, self.Y_)
        self.design_matrix = np.array(list(itertools.product(self.X_,
                                                             self.Y_)))

    def _setup_first(self):
        self.fig = plt.figure()
        if (self.true_function is not None) and (self.cost is not None):
            self.ax_true = self.fig.add_subplot(2, 2, 1, projection='3d')
            self.ax_opt = self.fig.add_subplot(2, 2, 2, projection='3d')
            self.ax_cost = self.fig.add_subplot(2, 2, 3)
            self.ax_utility = self.fig.add_subplot(2, 2, 4, projection='3d')
        elif self.true_function is not None:
            self.ax_true = self.fig.add_subplot(2, 2, 1, projection='3d')
            self.ax_opt = self.fig.add_subplot(2, 2, 2, projection='3d')
            self.ax_utility = self.fig.add_subplot(2, 2, 4, projection='3d')
        elif self.cost is not None:
            self.ax_opt = self.fig.add_subplot(2, 2, 2, projection='3d')
            self.ax_cost = self.fig.add_subplot(2, 2, 3)
            self.ax_utility = self.fig.add_subplot(2, 2, 4, projection='3d')
        else:
            self.ax_opt = self.fig.add_subplot(2, 2, 2, projection='3d')
            self.ax_utility = self.fig.add_subplot(2, 2, 4, projection='3d')
        self._setup_grid()

        if self.true_function is not None:
            self.ax_true.plot_surface(self.X, self.Y,
                                      self.true_function(self.X, self.Y))
            self.ax_true.view_init(self.phi, self.theta)

    def _update_plots(self):
        self._update_ax_utility()
        self._update_ax_opt()
        self._update_ax_cost()
        plt.pause(1e-15)

    def _update_ax_opt(self):
        self.ax_opt.clear()
        opt = self.optimizer
        ax_names = self.axis_names
        x_obs = np.array([[res["params"][ax_names[0]]] for res in opt.res])
        y_obs = np.array([[res["params"][ax_names[1]]] for res in opt.res])
        target_obs = np.array([res["target"] for res in opt.res])
        mu, sigma = posterior(self.optimizer, x_obs, y_obs, target_obs,
                              self.design_matrix)
        mu = np.resize(mu, (self.N, self.N))
        self.ax_opt.clear()
        self.ax_opt.plot_surface(self.X, self.Y, mu)
        self.ax_opt.view_init(self.phi, self.theta)
        self.ax_opt.plot([self.next_point[0], self.next_point[0]],
                         [self.next_point[1], self.next_point[1]],
                         [self.ax_opt.get_zlim()[0],
                          self.ax_opt.get_zlim()[1]],
                         'r-', linewidth=3)

    def _update_ax_utility(self):
        self.ax_utility.clear()
        # 2.576 is the default kappa value in bayes_opt source (for whatever
        # reason). The xi parameter is ignored when using UCB utility.
        self.utility_function = UtilityFunction(kind='ucb', kappa=2.576, xi=0)

        # Last argument (y_max) ignored when using UCB utility.
        utility = self.utility_function.utility(self.design_matrix,
                                                self.optimizer._gp, 0)
        utility = np.resize(utility, (self.N, self.N))

        self.ax_utility.plot_surface(self.X, self.Y, utility, alpha=0.8)
        ind = utility.argmax()
        i, j = np.unravel_index(ind, utility.shape)
        self.ax_utility.scatter(self.X_[i], self.Y_[j], np.amax(utility),
                                s=50, c='r')
        self.ax_utility.view_init(self.phi, self.theta)
        self.next_point = [self.X_[i], self.Y_[i], np.amax(utility)]

    def _update_ax_cost(self):
        t = np.empty(len(self.optimizer.res))
        for i, res in enumerate(self.optimizer.res):
            t[i] = res['target']
        self.ax_cost.plot(t)
